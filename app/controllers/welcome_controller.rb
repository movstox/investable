class WelcomeController < ApplicationController
  before_action :setup_filters
  def index2
  end

  def index
  end

  def search
    # by patent id
    @results = PatentIndex
      .where{patent_id =~ my{patent_id}}
    
    # by patent status
    @results = if patent_status_index_id > 0
                 @results
                  .where{patent_status_index_id == my{patent_status_index_id}}
               else
                 @results
               end

    # by institution
    @results = if institution_id > 0
                 @results
                  .where{institution_id == my{institution_id}}
               else
                 @results
               end

    # by keywords
    @results = if !params[:keywords].present? or params[:keywords].empty?
                 @results
               else
                 @results
                  .tagged_with(params[:keywords].split(','), :on => :keywords, :any => true)
               end

    # by inventors
    @results = if !params[:inventors].present? or params[:inventors].empty?
                 @results
               else
                 @results
                  .tagged_with(params[:inventors].split(','), :on => :inventors, :any => true)
               end
  end

  protected
  def setup_filters
    @institutions = Institution.all
    @stage_of_research = StageOfResearchIndex.all
    @patent_statuses = PatentStatusIndex.all
  end

  def patent_status_index_id
    params[:patent_status_index_id].to_i
  end

  def institution_id
    params[:institution_id].to_i
  end
  
  def patent_id
    "%#{params[:patent_id]}%"
  end
  
end
