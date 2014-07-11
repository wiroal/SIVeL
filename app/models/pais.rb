class Pais < ActiveRecord::Base
	has_many :clase, foreign_key: "id_pais", validate: true
	has_many :municipio, foreign_key: "id_pais", validate: true
	has_many :departamento, foreign_key: "id_pais", validate: true
	has_many :persona, foreign_key: "id_pais", validate: true
	has_many :ubicacion, foreign_key: "id_pais", validate: true
	has_many :desplazamiento, foreign_key: "paisdecl", validate: true
	has_many :victimasjr, foreign_key: "id_pais", validate: true
end