
ActiveAdmin.register Users do
  permit_params :name, :login, :password


  filter :name

  index do
    selectable_column
    id_column

    column :name
    column :created_at
    column :login
    column :password
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :login
      f.input :password

    end
    f.actions
  end


end