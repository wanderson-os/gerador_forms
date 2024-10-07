import type { IForm } from '../../pages/forms'
import { parse } from 'date-fns'

const form: IForm = {
  id: 450602694,
  name: 'form_aluminio',
  assayIds: [],
  sgqInfo: '',
  form: [
    { 
      id: 'field_1',
      name: 'field_1',
      label: 'Campo 1',
      type: 'text',
      fieldType: 'calculated',
      expression: data => {
        if (data['volume_naoh'] && data['bco_batelada']) {
          const n1 = Number(data['volume_naoh'])
          const n2 = Number(data['bco_batelada'])
          const n3 = Number(data['fatornaoh'])

          const res = (n1 - n2) * 1.65 * n3


          if (res < 0.2) {
            return '<0,2'
          }

          return res.toFixed(2)
        }

        return '-'
      },
      validate: value => {
        if (value.toString().trim() === '') {
          return 'Campo obrigatório'
        }
      }
    },
  ]
}
  
export default form