require 'sinatra/base'
require 'sinatra/partial'
require 'slim'
require 'sass'
require 'speed_gun'

class SpeedGun::App < Sinatra::Base
  configure do
    root_dir = File.join(File.dirname(__FILE__), 'app')
    set :root, root_dir
    set :public_folder, File.join(root_dir, 'public')
    set :views, File.join(root_dir, 'views')
    register Sinatra::Partial
    set :partial_template_engine, :slim
  end

  helpers do
    def source_line_id(filename, line)
      (@source_line_ids ||= {}).fetch("#{filename}:#{line}") do |key|
        Digest::MD5.hexdigest(key)
      end
    end
  end

  get '/report.css' do
    content_type 'text/css', charset: 'utf-8'
    scss :report
  end

  get '/reports/:id' do
    @report = SpeedGun.get_report(params[:id])
    halt 404 unless @report

    @sources = @report.sources
    @events = treeish_events(@report.events)

    slim :report
  end

  private

  def treeish_events(events)
    root = []
    prev_events = []
    events.sort_by(&:started_at).each do |event|
      prev_events.reject! { |pv| pv.roughly_finished_at < event.started_at }
      if prev_events.empty?
        root.push(event)
      else
        prev_events.last.children.push(event)
      end
      prev_events.push(event)
    end
    root
  end
end
