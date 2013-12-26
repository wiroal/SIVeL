require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe CasosController do

  # This should return the minimal set of attributes required to create a valid
  # Caso. As you add validations to Caso, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "titulo" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CasosController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all casos as @casos" do
      caso = Caso.create! valid_attributes
      get :index, {}, valid_session
      assigns(:caso).should eq([caso])
    end
  end

  describe "GET show" do
    it "assigns the requested caso as @caso" do
      caso = Caso.create! valid_attributes
      get :show, {:id => caso.to_param}, valid_session
      assigns(:caso).should eq(caso)
    end
  end

  describe "GET new" do
    it "assigns a new caso as @caso" do
      get :new, {}, valid_session
      assigns(:caso).should be_a_new(Caso)
    end
  end

  describe "GET edit" do
    it "assigns the requested caso as @caso" do
      caso = Caso.create! valid_attributes
      get :edit, {:id => caso.to_param}, valid_session
      assigns(:caso).should eq(caso)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Caso" do
        expect {
          post :create, {:caso => valid_attributes}, valid_session
        }.to change(Caso, :count).by(1)
      end

      it "assigns a newly created caso as @caso" do
        post :create, {:caso => valid_attributes}, valid_session
        assigns(:caso).should be_a(Caso)
        assigns(:caso).should be_persisted
      end

      it "redirects to the created caso" do
        post :create, {:caso => valid_attributes}, valid_session
        response.should redirect_to(Caso.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved caso as @caso" do
        # Trigger the behavior that occurs when invalid params are submitted
        Caso.any_instance.stub(:save).and_return(false)
        post :create, {:caso => { "titulo" => "invalid value" }}, valid_session
        assigns(:caso).should be_a_new(Caso)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Caso.any_instance.stub(:save).and_return(false)
        post :create, {:caso => { "titulo" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested caso" do
        caso = Caso.create! valid_attributes
        # Assuming there are no other caso in the database, this
        # specifies that the Caso created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Caso.any_instance.should_receive(:update).with({ "titulo" => "MyString" })
        put :update, {:id => caso.to_param, :caso => { "titulo" => "MyString" }}, valid_session
      end

      it "assigns the requested caso as @caso" do
        caso = Caso.create! valid_attributes
        put :update, {:id => caso.to_param, :caso => valid_attributes}, valid_session
        assigns(:caso).should eq(caso)
      end

      it "redirects to the caso" do
        caso = Caso.create! valid_attributes
        put :update, {:id => caso.to_param, :caso => valid_attributes}, valid_session
        response.should redirect_to(caso)
      end
    end

    describe "with invalid params" do
      it "assigns the caso as @caso" do
        caso = Caso.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Caso.any_instance.stub(:save).and_return(false)
        put :update, {:id => caso.to_param, :caso => { "titulo" => "invalid value" }}, valid_session
        assigns(:caso).should eq(caso)
      end

      it "re-renders the 'edit' template" do
        caso = Caso.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Caso.any_instance.stub(:save).and_return(false)
        put :update, {:id => caso.to_param, :caso => { "titulo" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested caso" do
      caso = Caso.create! valid_attributes
      expect {
        delete :destroy, {:id => caso.to_param}, valid_session
      }.to change(Caso, :count).by(-1)
    end

    it "redirects to the caso list" do
      caso = Caso.create! valid_attributes
      delete :destroy, {:id => caso.to_param}, valid_session
      response.should redirect_to(casos_url)
    end
  end

end
