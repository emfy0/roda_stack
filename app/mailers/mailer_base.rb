# frozen_string_literal: true

require 'roda/plugins/render'

class MailerBase
  DEFAULT_FROM = 'app@app.ru'

  def self.opts
    (@opts || @opts = {})
  end

  def self.inherited(subclass)
    subclass.opts.merge!(opts)
    super
  end

  def self.expand_path(*args)
    Roda.expand_path(*args)
  end

  renderer = Roda::RodaPlugins::Render

  include renderer::InstanceMethods
  extend renderer::ClassMethods

  renderer_opts = {
    views: 'views/mailers',
    layout: 'layout',
    escape: true
  }

  renderer.configure(self, renderer_opts)

  include Sidekiq::Job

  def self.perform(*args, **kwargs)
    new.perform(*args, **kwargs)
  end

  def html_text
    view(self.class.to_s.underscore)
  end

  def build_mail
    from_addr = @from || DEFAULT_FROM
    to_addr = @to
    subject_body = @subject

    @mail = Mail.new do
      from    from_addr
      to      to_addr
      subject subject_body
    end

    html_body = html_text

    @mail.html_part = Mail::Part.new do
      content_type 'text/html; charset=UTF-8'
      body html_body
    end

    @mail
  end

  def perform(*args, **kwargs)
    set_mail(*args, **kwargs)
    build_mail
    @mail.deliver
  end
end
