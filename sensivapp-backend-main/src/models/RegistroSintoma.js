const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const Paciente = require('./Paciente');

const RegistroSintoma = sequelize.define('RegistroSintoma', {
    id_registro: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    id_paciente: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Paciente,
            key: 'id_usuario'
        }
    },
    data_hora: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW 
    },
    nivel_sobrecarga: {
        type: DataTypes.INTEGER,
        allowNull: false,
        validate: {
            min: 1,
            max: 5
        }
    },
    anotacoes_diario: {
        type: DataTypes.TEXT,
        allowNull: true
    }
}, {
    tableName: 'Registros_Sintomas',
    timestamps: false 
});

Paciente.hasMany(RegistroSintoma, { foreignKey: 'id_paciente', onDelete: 'CASCADE' });
RegistroSintoma.belongsTo(Paciente, { foreignKey: 'id_paciente' });

module.exports = RegistroSintoma;