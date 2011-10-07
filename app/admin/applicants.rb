ActiveAdmin.register Applicant do  
  # menu :parent => "Applicants"
  
  filter :first_name
  filter :last_name
  
  form :partial => "form"
  
  index do
    column :first_name
    column :last_name
    
    # if can? :manage, Page
      default_actions
    # end
  end
  
  collection_action :import_csv, :method => :post do
    # Do some CSV importing work here...
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end
  
  controller do
   def create
    @applicant = Applicant.new(params[:applicant])

    respond_to do |format|
     @education = @applicant.educations.build(params[:applicant][:education_attributes])
     if @education.save
       
       if @applicant.save
         format.html { redirect_to(admin_applicants_path, :notice => 'Applicant was successfully created.') }
         format.xml  { render :xml => @applicant, :status => :created, :location => @applicant }
       else
         format.html { render :action => "new" }
         format.xml  { render :xml => @applicant.errors, :status => :unprocessable_entity }
       end
     end 
    end
   end
  end
end
