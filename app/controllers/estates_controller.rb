class EstatesController < ApplicationController
  authorize_resource
  before_action :set_estate, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: [:show, :room, :show_visited]
  after_action :update_status, only: %i[edit update]

  include EstatesHelper
  # GET /estates
  # GET /estates.json
  def index
    owner = helpers.current_owner
    if owner
      (@filterrific = initialize_filterrific(
          Estate.estates_by_owner(owner.id),
          params[:filterrific]
      )) || return
      @estates = @filterrific.find.page(params[:page]).per_page(10)
      respond_to do |format|
        format.html
        format.js
      end
      render :index, locals: {estates: @estates}
    else
      redirect_to new_owner_path, alert: "Para acceder a esta sección debe registrarse como propietario"
    end
  end

  def estates_visited
    email = current_user.email
    (@filterrific = initialize_filterrific(
        Estate.estates_by_client(email),
        params[:filterrific]
    )) || return
    @estates = @filterrific.find.page(params[:page]).with_deleted
    render :estates_visited, locals: {estates: @estates}

    respond_to do |format|
      format.html
      format.js
    end
  end

  def all_estates
    (filterrific = initialize_filterrific(
        Estate,
        params[:filterrific],
        )) || return
    estates = filterrific.find.order("owner_id asc, score asc, status desc").page(params[:page]).per_page(8)

    respond_to do |format|
      format.html
      format.js
    end
    render :all_estates, locals: {estates: estates, filterrific: filterrific}
  end

  # GET /estates/1
  def show
    (@filterrific = initialize_filterrific(
        Estate.with_rooms,
        params[:filterrific],
        select_options: {
            sorted_by: Estate.with_rooms.options_for_sorted_by,
        },
    )) || return
    @estates = @filterrific.find.page(params[:page])
    @date_from_formatted = Date.parse(params[:from])
    @date_to_formatted = Date.parse(params[:to])
    @diff = (@date_to_formatted.to_date - @date_from_formatted.to_date).to_i
    @plural_arg = (@diff > 1) ? "s" : " "
    date_from = params[:from]
    date_to = params[:to]
    price_max = ((params[:price_max] != '') && (params[:price_max] != nil)) ? params[:price_max] : 1000000000 #to do metodo y pasar los parametros
    price_min = ((params[:price_min] != '') && (params[:price_min] != nil)) ? params[:price_min] : 0
    max_capacity = ((params[:max_capacity] != '') && (params[:max_capacity] != nil)) ? params[:max_capacity] : 100
    min_capacity = ((params[:min_capacity] != '') && (params[:min_capacity] != nil)) ? params[:min_capacity] : 0
    @rooms = @estate.rooms.without_deleted.available(params[:id], date_from, date_to, price_max, price_min, max_capacity,min_capacity)
    @rooms.each do |room|
      quantity_available = Room.quantity_available(room.id, date_from, date_to).first
      room.quantity = quantity_available != nil ? quantity_available : 1
    end
    estate = @estate
    @facilities = estate.facilities_estates
    @images = estate.images
    @comments = Comment.where(estate_id: @estate.id)
    @offers = estate.offers
    email, name = get_user_email_name(params)
    can_comment = User.can_comment?(email, params[:id])
    respond_to do |format|
      format.html
      format.js
    end
    render :show, locals: {filterrific: @filterrific, city: params[:city], from: date_from, to: date_to, comments: @comments, can_comment: can_comment, email: email, name: name}
  end

  # GET /estates/new
  def new
    owner = Owner.find_by(user_id: current_user.id)
    if owner
      @estate = Estate.new
      @estate.owner_id = owner.id
      @estate.status = false
      @rooms = @estate.rooms.build
      @room_facilities = Facility.where(facility_type: :room)
      @estate_facilities = Facility.where(facility_type: :estate)
      render :new, locals: {rooms: @rooms, estate_facilities: @estate_facilities}
    else
      redirect_to new_owner_path, alert: "Para acceder a esta sección debe registrarse como propietario"
    end
  end

  # GET /estates/new_room
  def new_room
    @room = Room.new
  end

  # GET /estates/1/edit
  # room_facilities: @room_facilities, estate_facilities: estate_facilities
  def edit
    owner = Owner.find_by_user_id(current_user.id)
    if owner
      @rooms = Room.without_deleted.where(:estate_id => params[:id])
      @room_facilities = Facility.where(facility_type: :room)
      @estate_facilities = Facility.where(facility_type: :estate)
    else
      redirect_to new_owner_path, alert: "Para acceder a esta sección debe registrarse como propietario"
    end
  end

  def remove_image
    ActiveStorage::Blob.find_signed(params[:id]).attachments.first.purge_later
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  # POST /estates
  # POST /estates.json
  def create
    @estate = Estate.new(estate_params)
    @estate.isPublished

    convert_base64_to_file(@estate, params[:images])
    respond_to do |format|
      if @estate.save
        format.html { redirect_to estates_url, notice: 'Propiedad creada exitosamente.' }
        format.json { render :show, status: :created, location: @estate }
      else
        format.html { render :new, locals: {rooms: @rooms, estate_facilities: @estate_facilities} }
        format.json { render json: @estate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /estates/1
  # PATCH/PUT /estates/1.json
  def update
    convert_base64_to_file(@estate, params[:images])
    respond_to do |format|
      if @estate.update(estate_params)
        format.html { redirect_to show_detail_estate_path, notice: 'Propiedad actualizada exitosamente.' }
        format.json { render :show, status: :ok, location: @estate }
      else
        format.html { render :edit }
        format.json { render json: @estate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estates/1
  # DELETE /estates/1.json
  def destroy
    @estate.destroy
    respond_to do |format|
      format.html { redirect_to estates_url, notice: 'Propiedad eliminada exitosamente.' }
      format.json { head :no_content }
    end
  end

  # GET /estates/1/show_detail
  def show_detail
    email, name = get_user_email_name(params)
    @estate = Estate.find(params[:id])
    @rooms = @estate.rooms.without_deleted
    comments = @estate.commentsEstate
    render :show_detail, locals: {estate: @estate, comments: comments, can_comment: false, email: email, name: name}
  end

  # GET /estates/1/show_visited
  def show_visited
    email, name = get_user_email_name(params)
    @estate = Estate.with_deleted.find(params[:id])
    can_comment = @estate.deleted? ? false : User.can_comment?(email, params[:id])
    @rooms = @estate.rooms.without_deleted.where(status: 'published')
    comments = @estate.commentsEstate
    render :show_detail, locals: {estate: @estate, comments: comments, can_comment: can_comment, email: email, name: name}
  end

  def room
    @room = Room.with_deleted.find(params[:id])
    respond_to do |format|
      format.js {}
    end
  end

  # dar de baja una propiedad
  def unsuscribe_estate
    estate = Estate.find(params[:estate_id])
    rooms = estate.rooms

    respond_to do |format|
      #Si la reserva no tiene reservas en proceso.
      if !estate.have_bookings_in_process?

        #Cancelar reservas futuras y enviar correos a los clientes
        future_bookings = estate.get_future_bookings
        future_bookings.each do |b|
          b.update_attributes(:cancelled_at => Time.now, :booking_state => false)
          UserMailer.booking_cancelled_by_owner_to_client(b).deliver_now
        end

        # actualizar estado de las habitaciones
        rooms.each do |r|
          if r.status == 'published'
            r.update_attribute(:status, 'not_published')
          end
        end
        #actualizar el estado de la propiedad
        estate.update_attribute(:status, false)

        format.html { redirect_to estates_path, notice: 'Propiedad dada de baja exitosamente.' }
      else
        format.html { redirect_to estates_path, alert: 'No se puede dar de baja esta propiedad. Una o mas habitaciones estan ocupadas.' }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_estate
    @estate = Estate.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def estate_params
    params.require(:estate).permit(:name, :address, :city_id, :owner_id, :estate_type, :description, :booking_cancelable, :longitude, :latitude, facility_ids: [], rooms_attributes: [:id, :estate_id, :description, :capacity, :quantity, :price, :status, :room_type, :_destroy, facility_ids: [], images: []])
  end

  def current_ability
    @current_ability ||= EstateAbility.new(current_user)
  end

  def get_user_email_name (params)
    email, name = nil
    if params[:confirmation_token].present?
      booking = Booking.find_by_confirmation_token(params[:confirmation_token])
      email = booking.client_email
      name = booking.client_name
    elsif user_signed_in?
      email = current_user.email
      name = current_user.name #no se como se llama
    end
    return email, name
  end

  def update_status
    @estate.isPublished ? @estate.update_attribute(:status, true) : @estate.update_attribute(:status, false)
  end

end