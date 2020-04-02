 class EstateAbility
    include CanCan::Ability

    def initialize(user)
      #Si current_user existe, está logueado.
      if user.present?
        #Admin tiene acceso total.
        if user.has_role? :admin
          can :manage, :all
        else
          #owner existe si user tiene asociado un perfil de propietario
          owner ||= Owner.find_by user_id: user.id

          #User logueado.
          can :read, Estate
          can :create, Estate
          can :room, Estate
          #Solo un user con perfil de owner
          if owner
            can :update, Estate, owner_id: owner.id
            can :destroy, Estate, owner_id: owner.id
            can :show_detail, Estate, owner_id: owner.id
          end
        end
      else
        #Visitantes
        can :show, Estate
        can :create, Estate
        can :room, Estate
      end
    end
 end
