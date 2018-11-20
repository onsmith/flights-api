class ApplicationController < ActionController::API
  ## Includes
  # For: active_model_serializers gem
  # See: https://github.com/rails-api/rails-api#serialization
  include ActionController::Serialization

  # For: pundit
  # See: https://github.com/elabs/pundit#installation
  include Pundit

  # For: devise
  include ActionController::Cookies



  ## Handle Pundit unauthorized exceptions
  rescue_from Pundit::NotAuthorizedError, with: :action_forbidden
  private
    def action_forbidden
      head :forbidden
      render json: {}, status: :bad_request
    end



  ## Handle ActionController exceptions
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  private
    def parameter_missing(e)
      render json: {
        status: 400,
        error: 'Bad Request',
        exception: e
      }, status: :bad_request
    end



  ## Handle ActiveRecord exceptions
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  private
    def record_invalid(e)
      render json: {
        status: 422,
        error: 'Unprocessable Entity',
        exception: e
      }, status: :unprocessable_entity
    end



  ## Authentication filter method
  public
    def authenticate_user
      unless user_signed_in?
        render json: {
          status: 422,
          error: 'Unauthorized',
          exception: 'You must be logged in to access that endpoint'
        }, status: :unauthorized
        return false
      end
    end



  ## Provides a "where" filter to restrict results to only accessible records
  protected
    def records_are_accessible
      if user_signed_in?
        { user: [current_user, nil] }
      else
        { user: nil }
      end
    end



  ## Sorting methods
  protected
    def sort_params
      params[:sort]
        .to_s
        .split(',')
        .map(&:strip)
        .map { |s| s.start_with?('-') ? [s[1..-1], :desc] : [s, :asc]}
        .to_h
        .slice(*sorting_whitelist)
    end

    def sorting_whitelist
      [
        'id',
        'updated_at',
        'created_at'
      ]
    end



    ## Pagination methods
    protected
      DEFAULT_PAGE_SIZE = 1000000
      MAX_PAGE_SIZE     = 1000000

      def pagination_meta(collection)
        {
          current_page: collection.current_page,
          prev_page:    collection.prev_page,
          next_page:    collection.next_page,
          total_pages:  collection.total_pages,
          total_count:  collection.total_count,
          page_size:    pagination_size
        }
      end

      def pagination_number
        (params[:page][:number] rescue 1).to_i
      end

      def pagination_size
        [1, [MAX_PAGE_SIZE, (params[:page][:size] rescue DEFAULT_PAGE_SIZE).to_i].min].max
      end
end
