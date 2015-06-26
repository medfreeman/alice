class PostsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :edit, :new]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :feature]
  before_filter :set_studio, only: [:show, :index, :student_posts]
  before_filter :check_permission, only: [:new, :edit, :create]
  before_filter :prepare_form, only: [:new, :edit]

  def index
    if @studio.nil?
      @posts = Post.featured
    else
      @posts = @studio.posts
      @students = @studio.students
    end
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def student_posts
    @student = User.includes(:posts).find(params[:id])
    @students = @studio.students
    @posts   = @student.posts
  end

  # POST feature
  def feature
    if current_user.can_feature_post? @post
      @post.featured = params[:featured]
      @post.save!
      respond_to do |format|
        format.json {render json: @post}
        format.html {redirect_to request.referrer, notice: "The post has been featured"}
      end
    else
      respond_to do |format|
        format.json {render json: @post, status: :unprocessable_entity}
        format.html {redirect_to request.referrer, alert: "You do not have permission to feature this post"}
      end
    end
  end 

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to studio_post_path(@post.studio, @post), notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { 
          prepare_form
          render :new 
        }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to studio_post_path(@post.studio, @post), notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def check_permission
      if current_user.studio.nil? || !current_user.can_edit_post?(@post)
        redirect_to root_path, alert: "You must be assigned to a studio to write a new post" 
      end
    end

    def set_studio
      if params[:studio_id].present? 
        @studio = Studio.find(params[:studio_id])
      end
    end

    def post_params
      _params = params.require(:post).permit(:body, authors: [])
      _params[:authors].delete("")
      _params[:authors].each_with_index do |author, i|
        _params[:authors][i] = User.find(author.to_i)
      end
      _params[:authors] << current_user
      _params.merge(studio: current_user.studio)
    end

    def prepare_form
      @students = current_user.studio.students.select{|u| u != current_user}
    end
end
