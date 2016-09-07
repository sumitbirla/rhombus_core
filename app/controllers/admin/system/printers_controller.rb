require 'cupsffi'

class Admin::System::PrintersController < Admin::BaseController
  
  def index
    @printers = Printer.order(:name).page(params[:page])
  end

  def new
    @printer = Printer.new name: 'New printer'
    render 'edit'
  end

  def create
    @printer = Printer.new(printer_params)
    update_cups_properties(@printer)
    
    if @printer.save
      Rails.cache.delete :printers
      redirect_to action: 'index', notice: 'Printer was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @printer = Printer.find(params[:id])
  end

  def edit
    @printer = Printer.find(params[:id])
  end

  def update
    @printer = Printer.find(params[:id])
    update_cups_properties(@printer)
    
    if @printer.update(printer_params)
      redirect_to action: 'index', notice: 'Printer was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @printer = Printer.find(params[:id])
    @printer.destroy
    
    redirect_to action: 'index', notice: 'Printer has been deleted.'
  end
  
  
  private
  
    def printer_params
      params.require(:printer).permit!
    end
    
    def update_cups_properties(printer)
      # attempt to get printer info from CUPS server
      uri = URI(printer.url)
      if uri.scheme == 'ipp'
        printer_name = uri.path.split("/").last
        begin
          p = CupsPrinter.new(printer_name, hostname: uri.host)
          a = p.attributes
          printer.location = a["printer-location"] if printer.location.blank?
          printer.model = a["printer-make-and-model"]
        rescue => e
          flash[:error] = e.message
        end
      end
    end
end