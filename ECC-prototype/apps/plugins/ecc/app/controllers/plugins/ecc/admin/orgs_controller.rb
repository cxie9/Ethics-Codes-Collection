class Plugins::Ecc::Admin::OrgsController < Plugins::Ecc::AdminController
  before_action :set_ecc
  before_action :set_org, only: ['show','edit','update','destroy']
  include Plugins::Ecc
  def index
    @orgs = Orgs.paginate(:page => params[:page], :per_page => current_site.admin_per_page)
    render 'orgs_index'
  end

  def new
#    @org = @ecc.org.build
    @org = Orgs.new
    render 'orgs_new'
    add_breadcrumb("#{t('plugin.ecc.org.new')}")
  end

  def show
    render 'orgs_show'
  end

  def edit
  end

  def create
    new_org = params.require(:org).permit(:name, :desc)
    @org = Orgs.new(new_org)
    r = {org: @org}; hooks_run('org_create', r)
    if @org.save
      r = {org: @org}; hooks_run('org_created', r)
      flash[:notice] = t('camaleon_cms.admin.user.message.created')
      redirect_to action: :show
    else
      new
    end
  end

  def update
  end


  private
  def set_ecc
    @ecc = current_site.eccs.where(id: 22)
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Ecc not found"
    redirect_to orgs_path
  end
  def set_org
    @org = Orgs.find(params[:id])
  end
end
