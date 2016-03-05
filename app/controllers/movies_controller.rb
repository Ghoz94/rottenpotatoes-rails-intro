class MoviesController < ApplicationController

  def movie_params
    #0Added sort_type to denote how we wish to sort
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort_type)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
        
    @movies = Movie.all
    #set all_ratings with the list
    @all_ratings = Movie.list_of_ratings
    #if the ratings are checked, set the filter and add it to session and filter the movies
    if params[:ratings].nil? == false
      @filter = params[:ratings]
      session[:filter] = @filter
      @movies = @movies.select{ |movie| session[:filter].include? movie.rating}
    end
    
    #if there is a sort type, set the session
    if params[:sort_type].nil? == false
      session[:sort_type] = params[:sort_type]
    end
    
    #if no rating filter or sort type, redirect accordingly
    #if(params[:ratings].nil? == true && params[:sort_type].nil? == true)
     # @filter = session[:filter]
      #@sort_type = session[:sort_type]
      #flash.keep
      #redirect_to_movies_path({ratings: @filter, order_by: @sort_type})
    #end
    
    # based off sort_type, sort accordingly using ActiveRecord order and then filter it
    if session[:sort_type] == "title"
      @hltitle = "hilite"
      @movies = Movie.order(:title).select{ |movie| session[:filter].include? movie.rating}
    elsif session[:sort_type] == "date"
      @hldate = "hilite"
      @movies = Movie.order(:release_date).select{ |movie| session[:filter].include? movie.rating}
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
