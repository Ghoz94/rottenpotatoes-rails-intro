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
    Movie.list_of_ratings
    
    # based off sort_type, sort accordingly using ActiveRecord order
    if params[:sort_type] == "title"
      @hltitle = "hilite"
      @movies = Movie.order(:title)
    elsif params[:sort_type] == "date"
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
  
  #return array of ratings
  def self.list_of_ratings
    ratings_list = ['G','PG','PG-13','R','NC-17']
    return ratings_list
  end

end
