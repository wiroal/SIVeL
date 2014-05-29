# encoding: UTF-8
module Admin
  class IdiomasController < BasicasController
    before_action :set_clase, only: [:show, :edit, :update, :destroy]
    load_and_authorize_resource

    def clase 
      "idioma"
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_idioma
      @basica = Idioma.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def idioma_params
      params.require(:idioma).permit(
        :nombre, :fechacreacion, :fechadeshabilitacion
      )
    end

    def atributos_index
      ["id", "nombre", "fechacreacion", "fechadeshabilitacion"]
    end

    helper_method :clase, :atributos_index
  end
end
