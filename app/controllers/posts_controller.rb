class PostsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]
  before_filter :check_studio, only: [:new, :edit, :create]
  before_filter :prepare_form, only: [:new, :edit]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :feature]
  before_filter :set_studio, only: [:show, :index]

  def index
    if @studio.nil?
      @posts = Post.featured
    else
      @posts = @studio.posts
    end
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def feature
    if current_user.can_feature_post? @post
      @post.featured = params[:featured]
      @post.save!
      redirect_to request.referrer, notice: "The post has been featured"
    else
      redirect_to request.referrer, alert: "You do not have permission to feature this post"
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

    def check_studio
      redirect_to root_path, alert: "You must be assigned to a studio to write a new post" if current_user.studio.nil?
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
      _params
    end

    def prepare_form
      @students = current_user.studio.students.select{|u| u != current_user}
    end
end
