# == Schema Information
#
# Table name: core_printers
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  url         :string(255)      not null
#  print_count :integer          default(0), not null
#  model       :string(64)
#  location    :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'cupsffi'
require 'uri'
require 'socket'

class Printer < ActiveRecord::Base
  self.table_name = "core_printers"
  validates_presence_of :name, :url
  
  def to_s
    name
  end
  
  def print_file(file_path)
    uri = URI(url)
    
    if uri.scheme == 'ipp'
    
      printer_name = url.split("/").last
      printer = CupsPrinter.new(printer_name, hostname: uri.host, port: uri.port || 631)
      job = printer.print_file(file_path)
      return job
      
    elsif uri.scheme == 'socket'
      
      data = File.read(file_path)
      s = TCPSocket.new(uri.host, uri.port)
      s.send data, 0
      s.close
      
    end
  end
  
  def print_data(data, mime_type)
    uri = URI(url)
    
    if uri.scheme == 'ipp'
    
      printer_name = url.split("/").last
      
      puts "=> " + printer_name
      puts "=> " + uri.host
      
      printer = CupsPrinter.new(printer_name, hostname: uri.host, port: uri.port || 631)
      job = printer.print_data(data, mime_type)
      return job
      
    elsif uri.scheme == 'socket'
      
      s = TCPSocket.new(uri.host, uri.port)
      s.send data, 0
      s.close
      
    end
  end
end

