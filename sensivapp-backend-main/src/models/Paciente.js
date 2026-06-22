const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const Usuario = require('./Usuario'); 

const Paciente = sequelize.define('Paciente', {
    id_usuario: {
        type: DataTypes.INTEGER,
        primaryKey: true, 
        references: {
            model: Usuario,
            key: 'id_usuario'
        }
    },
    preferencia_tema: {
        type: DataTypes.STRING(20),
        defaultValue: 'claro'
    },
    data_nascimento: {
        type: DataTypes.DATEONLY, 
        allowNull: true
    },
    contato_emergencia: {
        type: DataTypes.STRING(100),
        allowNull: true
    }
}, {
    tableName: 'Pacientes',
    timestamps: false
});

Usuario.hasOne(Paciente, { foreignKey: 'id_usuario', onDelete: 'CASCADE' });
Paciente.belongsTo(Usuario, { foreignKey: 'id_usuario' });

module.exports = Paciente;