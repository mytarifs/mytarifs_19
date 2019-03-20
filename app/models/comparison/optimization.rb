# == Schema Information
#
# Table name: comparison_optimizations
#
#  id                    :integer          not null, primary key
#  name                  :string
#  description           :text
#  publication_status_id :integer
#  publication_order     :integer
#  optimization_type_id  :integer
#  slug                :string
#

class Comparison::Optimization < ActiveRecord::Base
  include FriendlyIdHelper
  friendly_id :slug_candidates, use: [:slugged]#, :finders]
  
  belongs_to :publication_status, :class_name =>'Content::Category', :foreign_key => :publication_status_id
  belongs_to :type, :class_name =>'Comparison::OptimizationType', :foreign_key => :optimization_type_id
  has_many :groups, :class_name =>'Comparison::Group', :foreign_key => :optimization_id
  has_many :result_runs, through: :groups
  
  scope :draft, -> {where(:publication_status_id => 100)}
  scope :reviewed, -> {where(:publication_status_id => 101)}
  scope :published, -> {where(:publication_status_id => 102)}
  scope :hidden, -> {where(:publication_status_id => 103)}

  def slug_candidates
    [
      :short_name_for_slug,
      :name,
      [:name, :privacy_and_region_from_id],
      [:name, :id],
    ]
  end
  
  def short_name_for_slug
    max_word_in_slug = 6;  excluded_short_word_length = 3;
    result = []
    i = 0
    name.split(" ").each do |word|
      result << word
      i += 1 if word.length > excluded_short_word_length
    end if name
    result[0..max_word_in_slug].join(" ")
  end
  
  def privacy_and_region_from_id
    m_privacy, m_region = RatingsDataLoader.privacy_region_from_id(id)
    "#{m_privacy}_#{m_region}"
  end
  
  def self.by_privacy_region(m_privacy, m_region) 
    rating_ids = RatingsDataLoader.ids_from_original_ids(RatingsDataLoader.original_ids, m_privacy, m_region)
    where(:id => rating_ids)
  end
  
  def self.by_privacy_region_with_fast_optimization(m_privacy, m_region)
    rating_ids = RatingsDataLoader.ids_from_original_ids(RatingsDataLoader.original_ids, m_privacy, m_region) + 
      [ FastOptimization::Data::InputRegionData[m_privacy][m_region][:optimization_id] ]
    where(:id => rating_ids)
  end
  

end

