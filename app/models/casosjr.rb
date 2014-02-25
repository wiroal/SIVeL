class Casosjr < ActiveRecord::Base
	has_many :ayudaestado_respuesta, foreign_key: "id_caso", validate: true, dependent: :destroy
	has_many :derecho_respuesta, foreign_key: "id_caso", validate: true, dependent: :destroy
	has_many :respuesta, foreign_key: "id_caso", validate: true, dependent: :destroy
	belongs_to :caso, foreign_key: "id_caso", validate: true, inverse_of: :casosjr
	belongs_to :contacto, class_name: "Persona", foreign_key: "contacto", validate: true
	belongs_to :regionsjr, foreign_key: "id_regionsjr", validate: true
	belongs_to :usuario, foreign_key: "asesor", validate: true
	belongs_to :statusmigratorio, foreign_key: "id_statusmigratorio", validate: true
	belongs_to :proteccion, foreign_key: "id_proteccion", validate: true
	belongs_to :idioma, foreign_key: "id_idioma", validate: true

	validates_presence_of :fecharec
	validates_presence_of :asesor
  validates_presence_of :regionsjr

	self.primary_key = :id_caso
end