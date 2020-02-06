class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort_by = params[:sort]
    @all_ratings = Movie.all_ratings
    
    @rate = params[:ratings]
    if  @rate.nil?
      @selected = @all_ratings
    elsif
      @selected = params[:ratings].keys
    end
    
    @movies = Movie.where(rating: @selected).order("#{@sort_by}").all
    
    if @sort_by == 'title' # highlight release data if sorting by release date
      @title_hilite = "hilite"
    elsif @sort_by == 'release_date' # highlight release data if sorting by release date
      @release_hilite = "hilite"
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
