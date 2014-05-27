module Contextify:User
    # Set the user's role for the current context
    # @param [String] name the name of the role
    #
    def set_role(name)
      Role.where(name: name.to_s).first_or_create!.tap do |role|
        self.role = role
      end
    end

    # Add a context for this user (as user must have at least one context to be functional)
    # A context describes the work capacity for the user eg; they might be an rto_admin for an Organisation
    # or an officer or officer for the application but not scoped to any particular entity
    #
    # @example Add a global context
    #
    #     user.add_context!(:manager)
    #
    # @example Add a context directly
    #
    #     user.add_context!(context)
    #
    # @example Add a context scoped to an Entity (Organisation in this case)
    #
    #     user.add_context!(:rto_admin, organisation)
    #
    # @example Add a new context and simultaneously make it the current context
    #
    #     user.add_context!(:admin, current: true)
    #
    # TODO: This is a nasty, complex method. Refactor! How does find in AR do it?
    def add_context!(*args)
      options = args.extract_options!
      context = role_name = nil
      if args.size == 1
        first_arg = args.first
        if (first_arg = args.first).is_a?(Context)
          context = first_arg
        else
          role_name = first_arg
        end
      else
        role_name, entity = args
      end
      if context.present?
        contexts << context
        save!
      else
        role = Role.where(name: role_name.to_s).first_or_create!
        context = contexts.create!(role: role, entity: entity)
      end
      context.tap do |context|
        switch_context!(context) if options[:current]
      end
    end

    def switch_context!(context)
    update_column(:current_context_id, context.id)
    end

     private
    def set_default_context
      if current_context.blank? || !contexts.include?(current_context)
        switch_context!(contexts.first) unless contexts.empty?
      end
    end

    def set_current_context(context)
      switch_context!(context) if current_context.blank?
    end

    # Unsets the current context
    def unset_current_context(context)
      if context == current_context
        self.current_context = nil
        self.current_context = contexts.first unless contexts.empty?
        save!
      end
    end
end
