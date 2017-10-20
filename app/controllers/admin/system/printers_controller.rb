require 'cupsffi'

class Admin::System::PrintersController < Admin::BaseController
  
  def index
    authorize Printer.new
    @printers = Printer.order(sort_column + " " + sort_direction)
                       .paginate(page: params[:page], per_page: @per_page)
  end

  def new
    @printer = authorize Printer.new(name: 'New printer')
    render 'edit'
  end

  def create
    @printer = authorize Printer.new(printer_params)
    update_cups_properties(@printer)
    
    if @printer.save
      Rails.cache.delete :printers
      redirect_to action: 'index', notice: 'Printer was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @printer = authorize Printer.find(params[:id])
  end

  def edit
    @printer = authorize Printer.find(params[:id])
  end

  def update
    @printer = authorize Printer.find(params[:id])
    update_cups_properties(@printer)
    
    if @printer.update(printer_params)
      redirect_to action: 'index', notice: 'Printer was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @printer = authorize Printer.find(params[:id])
    @printer.destroy
    
    redirect_to action: 'index', notice: 'Printer has been deleted.'
  end
  
  
  def print_url
    # check if download specified
    if params[:printer_id].blank?
      return redirect_to params[:url]
    end
    
    begin
      p = Printer.find(params[:printer_id])
      job = p.print_urls([params[:url]])
      flash[:success] = "Print job sent to #{p.name}.  CUPS Job ID: #{job.id}"
    rescue => e
      flash[:error] = e.message
    end
    
    redirect_to :back
  end
  
  
  private
  
    def printer_params
      params.require(:printer).permit!
    end
    
    def sort_column
      params[:sort] || "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
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
