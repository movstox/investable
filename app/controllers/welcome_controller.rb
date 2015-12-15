class WelcomeController < ApplicationController
  before_action :setup_filters
  def index2
  end

  def index
  end

  def search
    @results = PatentIndex
      .where{patent_id =~ my{patent_id}}
    @results = if patent_status_index_id > 0
                 @results
                  .where{patent_status_index_id == my{patent_status_index_id}}
               else
                 @results
               end
    @results = if institution_id > 0
                 @results
                  .where{institution_id == my{institution_id}}
               else
                 @results
               end
    @results = if !params[:keywords].present? or params[:keywords].empty?
                 @results
               else
                 @results
                  .tagged_with(params[:keywords].split(','), :any => true)
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
