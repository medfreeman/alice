class PostsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :edit, :new]
  before_filter :check_locked!, only: [:create, :edit, :new]
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
          @posts = Post.year(@year).page(params[:page]).per(5)
        elsif params[:slug].blank?
          @posts = User.year(@year).map{|u| u.posts.year(@year).where(featured:true).limit(1).first}.compact
          render :home
        else
          @student = User.includes(:posts).find(params[:slug])
          @posts = @student.posts.year(@year).page(params[:page]).per(5)
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
        @posts = @studio.posts.page(params[:page]).per(5)
        @most_recent = true
      else
        @posts = @studio.featured_posts.page(params[:page]).per(5)
      end
      @students = @studio.students
    end
  end

  def show
    if !@post.category_list.empty?
      @page_title = @post.category_list[0]
      @title = @post.category_list[0]
    elsif @post.year.display_by_users?
      @page_title = "BLOG #{@post.year.slug}"
      @title = "BLOG #{@post.year.slug}"
    else
      @page_title =  "Studio #{@post.studio.name}"
      @title = @post.studio.name.titleize
    end
  end

  def new
    @categories = Post.tags_on(:categories)
    @tags = current_user.studio.tags
    @page_title = 'New Post'
    @title = "New Post"
  end

  def edit
    prepare_form
    @page_title = 'Edit'
    @title = "Edit Post"
  end

  def tagged_posts
    @tag = ActsAsTaggableOn::Tag.friendly.find(params[:slug])
    if @studio
      @title = "#{@studio.name.titleize} – #{@tag.name.titleize}"
      @posts = @studio.posts.page(params[:page]).per(5).tagged_with(@tag)
      @page_title = "Studio #{@studio.name}"
    else
      @posts = Post.year(@year).page(params[:page]).per(5).tagged_with(@tag.name, on: :categories)
      @title = @tag.name.titleize
      @page_title = @tag.name.titleize
    end
    render :index
  end

  def student_posts
    @student = User.includes(:posts).find(params[:id])
    @title = @student.name
    @students = @studio.students
    @posts   = @student.posts.year(@year).page(params[:page]).per(5)
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
          path = @post.studio.nil? ? year_category_post_path(@year, @post.tags_on(:categories).first, @post) : year_studio_post_path(@year, @post.studio, @post)
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
      @post = params[:slug].present? || params[:id].present? ? Post.includes(:studio).find(params[:id] || params[:slug]) : Post.new

    end

    def check_permission
      return if current_user.admin? || current_user.super_director?
      if current_user.studio.nil? || !current_user.can_edit_post?(@post)
        redirect_to root_path, alert: "You must be assigned to a studio to write a new post"
      end
    end

    def set_studio
      if params[:studio_id].present?
        begin
          @studio = Studio.year(@year).find(params[:studio_id])
        rescue => e
        	redirect_to year_path(@year)
        end
      end
    end

    def post_params
      _params = params
      if current_user.can_edit_categories?
        _params = params.require(:post).permit(:id, :year_id, :studio_id, :thumbnail, :status, :body, :title, :category_list, :tag_list, category_list: [], tag_list: [], authors: [])
      else
        _params = params.require(:post).permit(:id, :year_id, :studio_id, :thumbnail, :status, :body, :title, :tag_list, tag_list: [], authors: [])
      end
      if !_params[:authors].blank?
        _params[:authors].delete("")
        _params[:authors].each_with_index do |author, i|
          _params[:authors][i] = User.find(author.to_i)
        end
      else
        _params[:authors] = []
      end
      _params.delete(:tag_list) if !_params[:category_list].blank?
      _params.merge!(studio_id: current_user.studio.id) if _params[:category_list].blank? && _params[:studio_id].blank?
p       _params
_params
    end

    def prepare_form
      @students = current_user.studio.users.order(:name)
      @selected_categories = @post.tags_on(:categories)
      @selected_tags = @post.tags_on(:tags)
      @categories = Post.tags_on(:categories)
      @tags = current_user.studio.tags
    end

    def check_studio
      redirect_to root_path, notice: "You are not assigned to any studio yet" if current_user.studio.nil?
    end

    def after_save_post_path(post)
      @year.display_by_users? ?
        year_student_post_path(post.year, post.first_author, post) :
        post.studio.nil? ?

          year_category_post_path(year, post.tags_on(:categories).first.slug, post) :
          year_studio_post_path(post.year, post.studio, post)
    end
end
