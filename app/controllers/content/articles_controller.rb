class Content::ArticlesController < ApplicationController
  include Crudable
  crudable_actions :all

  include SavableInSession::Tableable, Content::ArticlesHelper
  helper SavableInSession::Tableable, Content::ArticlesHelper
  
  before_filter :check_before_friendly_url, only: [:mobile_article]
  before_filter :check_articles_select_before_filtr, only: [:index]

  add_breadcrumb "Список статей по мобильной связи", nil, only: ['mobile_articles']
  add_breadcrumb "Вопросы и ответы", nil, only: ['questions_and_answers'] #:content_questions_and_answers_path
  
  def mobile_article
    add_breadcrumb "Список статей по мобильной связи", content_mobile_articles_path(hash_with_region_and_privacy)
    add_breadcrumb "Статья по мобильной связи"#, content_mobile_article_path(params[:id])
  end

  def check_before_friendly_url
    if params[:id] == 'opisanie_tarifa_mts_transformische'
      redirect_to tarif_class_path(hash_with_region_and_privacy({:id => 'transformische'})), :status => :moved_permanently
    else
      @content_article = Content::Article.where(:id => params[:id]).first
      if @content_article and request.path != content_mobile_article_path(@content_article, trailing_slash: false)
        redirect_to content_mobile_article_path(@content_article), :status => :moved_permanently
      end if params[:id]
    end
  end
  
end
