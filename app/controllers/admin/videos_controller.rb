class Admin::VideosController < AdminController

	def index
		set_videos
	end

	def new
		new_video
	end

	def edit
		set_video
	end

	def create
		@video = Video.new(video_params)
		if @video.save
			redirect_to admin_videos_path, notice: 'You have created a new video'
		else
			render action: :new
		end
	end

	def update
		set_video
		if @video.update_attributes(video_params)
			redirect_to admin_videos_path, notice: 'You have updated a video'
		else
			render action: :edit
		end
	end

	def destroy
    	set_video
    	@video.destroy
    	redirect_to admin_videos_path(@video), notice: 'You have successfully deleted a video.'
  	end

	private

	def set_video
		@video ||= Video.find(params[:id])
	end

	def set_videos
		@videos = Video.all
	end
  
	def new_video
		@video = Video.new
	end

	def video_params
		params.require(:video).permit(:url, :type, :category, :language)
	end
end