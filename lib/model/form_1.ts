import type { IForm } from '../../pages/forms'
import { parse } from 'date-fns'

const form: IForm = {
  id: 795897045,
  name: 'Formulário 1',
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
        const n1 = data['field_1']
        const n2 = data['field_1']

        if (n1 + n2 == 2) {
          return 'Aprovado'
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