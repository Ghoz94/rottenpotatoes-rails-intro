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
    #if the ratings are checked, set the filter and add it to session
    if params[:ratings].nil? == false
      @filter = params[:ratings]
      session[:filter] = @filter
    end
    
    #filter the movies
    #if the ratings are checked, set the filter and add it to session
    if params[:ratings].nil? == false
        @movies = @movies.select{ |movie| session[:filter].include? movie.rating}
    end
    
    session[:sort_type] = params[:sort_type]
    # based off sort_type, sort accordingly using ActiveRecord order
    if session[:sort_type] == "title"
      @hltitle = "hilite"
      @movies = Movie.order(:title)
    elsif session[:sort_type] == "date"
      @hldate = "hilite"
      @movies = Movie.order(:release_date)
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
