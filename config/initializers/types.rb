ActiveSupport.on_load(:active_record) do
  ActiveRecord::Type.register(:nilify_blanks, NilifyBlanksType)
end
