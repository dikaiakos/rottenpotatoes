# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  def index


    redirect = false

    if params[:reset]
      session.clear
      @movies = Movie.where(rating: Movie::RATINGS)
    else
      # retrieve params from user and/or session
      # if params retrieved from session, set redirect to true in order
      # to restore them
      if params[:ratings] != nil
        @ratings = params[:ratings].keys
        session[:ratings] = @ratings
      elsif session[:ratings] != nil
        @ratings = session[:ratings]
        redirect = true
      else
        @ratings = Movie::RATINGS
      end

      if params[:sort] != nil
        @hilite = params[:sort]
        session[:sort] = @hilite
      elsif session[:sort] != nil
        @hilite = session[:sort]
        redirect = true
      else
        @hilite = nil
      end

      # clear session, recreate params based on session extracted contents
      # and redirect
      if redirect
        session.clear
        ratings_param_list = Hash.new("1")
        @ratings.each {|key| ratings_param_list[key] = "1"}
        flash.keep
        redirect_to movies_path(sort: @hilite, ratings: ratings_param_list)
      else
        @movies = Movie.where(rating: @ratings).order(@hilite)
      end
    end
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # Look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
