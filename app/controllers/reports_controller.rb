# frozen_string_literal: true

# reports controller
class ReportsController < ApplicationController
  load_and_authorize_resource

  def index; end

  # alojamientos mas valoradosPa
  def most_valuated_estates
    (@filterrific = initialize_filterrific(
      Estate.best_estates,
      params[:filterrific]
    )) || return
    @estates = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html do
        render :most_valuated_estates, locals: {estates: @estates}
      end
      format.pdf do
        render locals: {estates: @estates},
               template: "reports/most_valuated_estates.pdf.erb",
               page_size: 'A4',
               header:  {
                   html: {
                       template: 'layouts/partials/_pdf_header.html.erb',
                       layout: 'layouts/decoration_pdf.html.erb'
                   }
               },
               footer:  {
                   html: {
                       template: 'layouts/partials/_pdf_footer.html.erb',
                       layout: 'layouts/decoration_pdf.html.erb'
                   }
               },
               pdf: "Propiedades_mas_valuadas.pdf"
        end
      format.js
    end


  end

  # alojamientos mas comentados
  def most_commented_estates
    (@filterrific = initialize_filterrific(
      Estate.most_commented,
      params[:filterrific]
    )) || return
    @estates = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html do
        render :most_commented_estates, locals: {estates: @estates}
      end
      format.js
      format.pdf do
        render locals: {estates: @estates},
               template: "reports/most_commented_estates.pdf.erb",
               page_size: 'A4',
               header:  {
                   html: {
                       template: 'layouts/partials/_pdf_header.html.erb',
                       layout: 'layouts/decoration_pdf.html.erb'
                   }
               },
               footer:  {
                   html: {
                       template: 'layouts/partials/_pdf_footer.html.erb',
                       layout: 'layouts/decoration_pdf.html.erb'
                   }
               },
               pdf: "Propiedades_mas_comentadas.pdf"
      end
    end
  end

  # alojamientos mas reservados
  def most_booked_estates
    (@filterrific = initialize_filterrific(
        Estate.most_booked,
        params[:filterrific]
    )) || return
    @estates = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html do
        render :most_booked_estates, locals: {estates: @estates}
      end
      format.js
      format.pdf do
        render locals: {estates: @estates},
               template: "reports/most_booked_estates.pdf.erb",
               page_size: 'A4',
               header:  {
                   html: {
                       template: 'layouts/partials/_pdf_header.html.erb',
                       layout: 'layouts/decoration_pdf.html.erb'
                   }
               },
               footer:  {
                   html: {
                       template: 'layouts/partials/_pdf_footer.html.erb',
                       layout: 'layouts/decoration_pdf.html.erb'
                   }
               },
               pdf: "Propiedades_mas_visitadas.pdf"
      end
    end

  end

  private

  def current_ability
    @current_ability ||= ReportAbility.new(current_user)
  end
end
