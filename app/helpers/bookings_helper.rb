module BookingsHelper

  def get_status(booking)

    date_end = booking.date_end
    date_start = booking.date_start
    today = Date.today

    is_not_canceled = booking.cancelled_at == nil

    status = %w(Vigente Terminada Pendiente Cancelada)

    if (is_not_canceled)
      if (date_start <= today && date_end >= today)
        status.first
      elsif (date_end < today)
        status.second
      elsif (date_end > today)
        status.third
      end
    else
      status.fourth
    end
  end

  def get_status_color(status_booking)
    status = %w(Vigente Terminada Pendiente Cancelada)
    colors = %w(success warning info danger)
    case status_booking
    when status.first
      colors.first
    when status.second
      colors.second
    when status.third
      colors.third
    else
      colors.fourth
    end
  end

  def is_cancellable?(estate)
		estate.booking_cancelable
  end

  def is_my_booking?(booking)
    current_user.email == booking.client_email
  end
end
