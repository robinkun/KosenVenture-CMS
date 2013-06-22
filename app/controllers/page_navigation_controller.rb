# encoding: utf-8

class PageNavigationController < ApplicationController
  caches_page :navigate # ページキャッシュを取る
  before_filter :page_finder, only: [:navigate]
  layout 'kvp'

  def navigate
    @page_title = @page.title
    # descriptionがセットされている場合はfbのリンクをページに
    @fb_ogp = {
      title: @page_title ? "#{@page_title}｜#{@site_config.title}" : @site_config.title,
      url: @page.path,
      description: @page.description
    } unless @page.description.blank?

    render inline: @page.body, layout: true
  end

  private

  # ページを探す
  def page_finder
    if params[:path]
      @page = Page.published.find_by_path!('/' + params[:path])
    else
      # 空のときはindexページを探す
      @page = Page.published.find_by_path!('/index')
    end
  end
end
