require_relative "spec_helper"

describe "openstack-image::identity_registration" do
  before do
    @identity_register_mock = double "identity_register"
  end

  it "registers image service" do
    image_stubs
    ::Chef::Recipe.any_instance.stub(:openstack_identity_register)
    ::Chef::Recipe.any_instance.should_receive(:openstack_identity_register).
      with("Register Image Service") do |&arg|
        @identity_register_mock.should_receive(:auth_uri).
          with "https://127.0.0.1:35357/v2.0"
        @identity_register_mock.should_receive(:bootstrap_token).
          with "bootstrap-token"
        @identity_register_mock.should_receive(:service_name).
          with "glance"
        @identity_register_mock.should_receive(:service_type).
          with "image"
        @identity_register_mock.should_receive(:service_description).
          with "Glance Image Service"
        @identity_register_mock.should_receive(:action).
          with :create_service

        @identity_register_mock.instance_eval &arg
      end

    chef_run = ::ChefSpec::ChefRunner.new ::UBUNTU_OPTS
    chef_run.converge "openstack-image::identity_registration"
  end

  it "registers image endpoint" do
    image_stubs
    ::Chef::Recipe.any_instance.stub(:openstack_identity_register)
    ::Chef::Recipe.any_instance.should_receive(:openstack_identity_register).
      with("Register Image Endpoint") do |&arg|
        @identity_register_mock.should_receive(:auth_uri).
          with "https://127.0.0.1:35357/v2.0"
        @identity_register_mock.should_receive(:bootstrap_token).
          with "bootstrap-token"
        @identity_register_mock.should_receive(:service_type).
          with "image"
        @identity_register_mock.should_receive(:endpoint_region).
          with "RegionOne"
        @identity_register_mock.should_receive(:endpoint_adminurl).
          with "https://127.0.0.1:9292/v2"
        @identity_register_mock.should_receive(:endpoint_internalurl).
          with "https://127.0.0.1:9292/v2"
        @identity_register_mock.should_receive(:endpoint_publicurl).
          with "https://127.0.0.1:9292/v2"
        @identity_register_mock.should_receive(:action).
          with :create_endpoint

        @identity_register_mock.instance_eval &arg
      end

    chef_run = ::ChefSpec::ChefRunner.new ::UBUNTU_OPTS
    chef_run.converge "openstack-image::identity_registration"
  end

  it "registers service tenant" do
    image_stubs
    ::Chef::Recipe.any_instance.stub(:openstack_identity_register)
    ::Chef::Recipe.any_instance.should_receive(:openstack_identity_register).
      with("Register Service Tenant") do |&arg|
        @identity_register_mock.should_receive(:auth_uri).
          with "https://127.0.0.1:35357/v2.0"
        @identity_register_mock.should_receive(:bootstrap_token).
          with "bootstrap-token"
        @identity_register_mock.should_receive(:tenant_name).
          with "service"
        @identity_register_mock.should_receive(:tenant_description).
          with "Service Tenant"
        @identity_register_mock.should_receive(:tenant_enabled).
          with true
        @identity_register_mock.should_receive(:action).
          with :create_tenant

        @identity_register_mock.instance_eval &arg
      end

    chef_run = ::ChefSpec::ChefRunner.new ::UBUNTU_OPTS
    chef_run.converge "openstack-image::identity_registration"
  end

  it "registers service user" do
    image_stubs
    ::Chef::Recipe.any_instance.stub(:openstack_identity_register)
    ::Chef::Recipe.any_instance.should_receive(:openstack_identity_register).
      with("Register glance User") do |&arg|
        @identity_register_mock.should_receive(:auth_uri).
          with "https://127.0.0.1:35357/v2.0"
        @identity_register_mock.should_receive(:bootstrap_token).
          with "bootstrap-token"
        @identity_register_mock.should_receive(:tenant_name).
          with "service"
        @identity_register_mock.should_receive(:user_name).
          with "glance"
        @identity_register_mock.should_receive(:user_pass).
          with "glance-pass"
        @identity_register_mock.should_receive(:user_enabled).
          with true
        @identity_register_mock.should_receive(:action).
          with :create_user

        @identity_register_mock.instance_eval &arg
      end

    chef_run = ::ChefSpec::ChefRunner.new ::UBUNTU_OPTS
    chef_run.converge "openstack-image::identity_registration"
  end

  it "grants admin role to service user for service tenant" do
    image_stubs
    ::Chef::Recipe.any_instance.stub(:openstack_identity_register)
    ::Chef::Recipe.any_instance.should_receive(:openstack_identity_register).
      with("Grant 'admin' Role to glance User for service Tenant") do |&arg|
        @identity_register_mock.should_receive(:auth_uri).
          with "https://127.0.0.1:35357/v2.0"
        @identity_register_mock.should_receive(:bootstrap_token).
          with "bootstrap-token"
        @identity_register_mock.should_receive(:tenant_name).
          with "service"
        @identity_register_mock.should_receive(:role_name).
          with "admin"
        @identity_register_mock.should_receive(:user_name).
          with "glance"
        @identity_register_mock.should_receive(:action).
          with :grant_role

        @identity_register_mock.instance_eval &arg
      end

    chef_run = ::ChefSpec::ChefRunner.new ::UBUNTU_OPTS
    chef_run.converge "openstack-image::identity_registration"
  end
end
