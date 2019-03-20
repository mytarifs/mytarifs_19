# == Schema Information
#
# Table name: content_articles
#
#  id         :integer          not null, primary key
#  author_id  :integer
#  title      :string
#  content    :json
#  type_id    :integer
#  status_id  :integer
#  key        :json
#  created_at :datetime
#  updated_at :datetime
#

class Content::Article < ActiveRecord::Base
  include WhereHelper, FriendlyIdHelper
  friendly_id :slug_candidates, use: [:slugged]

  Content::Article::PublishStatus = {:draft => 100, :reviewed => 101, :published => 102, :hidden => 103}
  Content::Article::Type = {:tarif_description => 1, :comparison_description => 2, :comparison_by_operator_description => 3, :general_articles => 4}
  
  store_accessor :key, :tarif_id, :comparison_id, :operator_id, :m_region
  store_accessor :content, :content_title, :use_content_title, :content_body, :is_noindex,
    :tag_site, :tag_title, :use_tag_title, :tag_description, :tag_keywords, :image_name, :image_title
  
  belongs_to :author, :class_name =>'User', :foreign_key => :author_id

  scope :tarif_description, -> {where(:type_id => Content::Article::Type[:tarif_description])}
  scope :comparison_description, -> {where(:type_id => Content::Article::Type[:comparison_description])}
  scope :comparison_by_operator_description, -> {where(:type_id => Content::Article::Type[:comparison_by_operator_description])}
  scope :general_articles, -> {where(:type_id => Content::Article::Type[:general_articles])}

  scope :draft, -> {where(:status_id => Content::Article::PublishStatus[:draft])}
  scope :reviewed, -> {where(:status_id => Content::Article::PublishStatus[:reviewed])}
  scope :published, -> {where(:status_id => Content::Article::PublishStatus[:published])}
  scope :hidden, -> {where(:status_id => Content::Article::PublishStatus[:hidden])}
  
  def slug_candidates
    [
      :title,
    ]
  end

  def publish_status_name
    Content::Article::PublishStatus.key(status_id.try(:to_i))
  end
  
  def type_name
    Content::Article::Type.key(type_id.try(:to_i))
  end
  
  #Content::Article.copy_all_region_articles_to_new_region('moskva_i_oblast', 'sankt_peterburg_i_oblast')
  def self.copy_all_region_articles_to_new_region(source_region, target_region)
    return false if source_region.blank? or target_region.blank?
    ActiveRecord::Base.transaction do
      source_region_name = ::Category::MobileRegions[source_region].try(:[], 'name')
      target_region_name = ::Category::MobileRegions[target_region].try(:[], 'name')

      where("tarif_classes.features->>'region_txt' = '#{source_region}'").
        joins("left join tarif_classes on (tarif_classes.id)::text = (content_articles.key->>'tarif_id')").
        select("tarif_classes.name as tarif_class_name, tarif_classes.privacy_id as privacy_id, tarif_classes.standard_service_id as standard_service_id, \
          tarif_classes.operator_id as operator_id, content_articles.*").each do |origin_article|
          
        raise(StandardError) if !origin_article.author_id
        
        existing_target_tarif_class = TarifClass.where("features->>'region_txt' = '#{target_region}'").
            where(:name => origin_article.tarif_class_name, :operator_id => origin_article.operator_id).
            where(:privacy_id => origin_article.privacy_id, :standard_service_id => origin_article.standard_service_id).first
        
        if existing_target_tarif_class
          tarif_description.where("(content_articles.key->>'tarif_id')::integer = #{existing_target_tarif_class.id}").first_or_create! do |new_article|
            new_article.author_id = origin_article.author_id
            new_article.title = origin_article.title
            new_article.type_id = origin_article.type_id
            new_article.status_id = Content::Article::PublishStatus[:draft]
            new_article.tarif_id = existing_target_tarif_class.id
            new_article.operator_id = existing_target_tarif_class.operator_id
            
            new_article.content_body = origin_article.content_body
          end

        end
      end
    end

  end
  
  #Content::Article.mass_update_content
  def self.mass_update_content
    result = []
    tarif_description.each do |item|
        tarif_class = TarifClass.where(:id => item.key.try(:[], 'tarif_id').try(:to_i)).first
        if tarif_class and !tarif_class.region_txt.blank?
          item.key ||= {}
          next if !item.key['m_region'].blank?
          existing_m_region = item.key['m_region']
          item.key['m_region'] = tarif_class.region_txt
#            item.save
          result << [item.key['m_region'], existing_m_region, tarif_class.name, item.title].to_s
        end

    end
    puts result
    nil
  end
end

