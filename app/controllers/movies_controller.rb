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
    @all_ratings = Movie.all_ratings
    if (params[:sort].nil? and params[:ratings].nil? and session[:ratings].nil? and session[:sort].nil?)
      @selected = @all_ratings
      @movies = Movie.all
      @title_hilite = nil
      @release_hilite = nil
    else
      @sort_by = params[:sort]
      if @sort_by.nil?
        @sort_by = session[:sort]
      else
        session[:sort] = @sort_by
      end
      
      if @sort_by == 'title' # highlight title if sorting by title
        @title_hilite = "hilite"
      elsif @sort_by == 'release_date' # highlight release data if sorting by release date
        @release_hilite = "hilite"
      end

      @rate = params[:ratings]
      if  @rate.nil? and session[:ratings].nil?
        @selected = @all_ratings
      elsif  @rate.nil?
        @selected = session[:ratings]
      else
        @selected = params[:ratings].keys
        session[:ratings] = @selected
      end
      
      @movies = Movie.with_ratings(@selected).order("#{@sort_by}").all
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
