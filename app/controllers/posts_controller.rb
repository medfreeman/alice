class PostsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :edit, :new]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :feature, :new]
  before_action :set_studio, only: [:show, :index, :student_posts, :tagged_posts]
  before_filter :check_permission, only: [:new, :edit, :create]
  before_filter :check_studio, only: [:new, :edit, :create]
  before_action :prepare_form, only: [:new, :edit]

  def index
    if @studio.nil?
      @title = "Home"
      @page_title = "Blog Homepage"
      if @year.display_by_users?
        if params[:filter] == :most_recent
          @posts = Post.year(@year)
        elsif params[:slug].blank?
          @posts = User.year(@year).map{|u| u.posts.where(featured:true).limit(1).first}.compact
          render :home
        else
          @student = User.includes(:posts).find(params[:slug])
          @posts = @student.posts
          @page_title = @student.name
          @title = @student.name
        end
      else
        @posts = Studio.year(@year).map{|s| s.featured_posts.limit(1).order("created_at DESC").first}.compact
        render :home
      end
    else
      @title = @studio.name.titleize
      @page_title = "Studio #{@studio.name}"
      if params[:filter] == :most_recent
        @posts = @studio.posts
        @most_recent = true
      else
        @posts = @studio.featured_posts
      end
      @students = @studio.students
    end
  end

  def show
  end

  def new
    @categories = Post.tags_on(:categories)
    @tags = current_user.studio.tags
  end

  def edit
    @categories = Post.tags_on(:categories)
    @tags = current_user.studio.tags
    prepare_form
  end

  def tagged_posts
    @tag = ActsAsTaggableOn::Tag.friendly.find(params[:slug])
    if @studio 
      @title = "#{@studio.name.titleize} – #{@tag.name.titleize}"
      @posts = @studio.posts.tagged_with(@tag)
      @page_title = "Studio #{@studio.name}"
    else
      @posts = Post.year(@year).tagged_with(@tag.name, on: :categories)
      @title = @tag.name.titleize
      @page_title = @tag.name.titleize
    end
    render :index
  end

  def student_posts
    @student = User.includes(:posts).find(params[:id])
    @title = @student.name
    @students = @studio.students
    @posts   = @student.posts
    @page_title = "Studio #{@studio.name}"
    render :index
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
        format.html { 
          path = after_save_post_path(@post)
          redirect_to path, notice: 'Post was successfully created.' 
        }
        format.json { render :show, status: :created, location: @post }
      else
        prepare_form
        @tags = current_user.studio.tags
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
        format.html { 
          path = @post.studio.nil? ? category_post_path(@post.tags_on(:categories).first, @post) : studio_post_path(@post.studio, @post)
          redirect_to path, notice: 'Post was successfully updated.' }
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
      format.html { redirect_to root_path, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_post
      @post = params[:id].present? ? Post.includes(:studio).find(params[:id]) : Post.new
    end

    def check_permission
      return if current_user.admin?
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
      _params = params
      if current_user.can_edit_categories?
        _params = params.require(:post).permit(:id, :year_id, :thumbnail, :status, :body, :title, :category_list, category_list: [], tag_list: [], authors: [])
      else
        _params = params.require(:post).permit(:id, :year_id, :thumbnail, :status, :body, :title, tag_list: [], authors: [])
      end
      if !_params[:authors].blank?
        _params[:authors].delete("") 
        _params[:authors].each_with_index do |author, i|
          _params[:authors][i] = User.find(author.to_i)
        end
      else 
        _params[:authors] = []
      end
      _params[:authors] << current_user
      _params.delete(:tag_list) if !_params[:category_list].blank?
      _params.merge!(studio_id: current_user.studio.id) if _params[:category_list].blank?
      _params
    end

    def prepare_form
      @students = current_user.studio.students.select{|u| u != current_user}
      @selected_categories = @post.tags_on(:categories)
      @selected_tags = @post.tags_on(:tags)
    end

    def check_studio
      redirect_to root_path, notice: "You are not assigned to any studio yet" if current_user.studio.nil?
    end
    
    def after_save_post_path(post)
    post.studio.nil? ? 
      category_post_path(post.tags_on(:categories).first, post, current_year: @year) : 
      studio_post_path(post.studio, post, current_year: @year)
  end
end

