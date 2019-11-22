using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DTO
{
    class TypeDish
    {
        public TypeDish (string type_dish)
        {
            this.Type_dish = type_dish;
        }

        private string type_dish;

        public string Type_dish
        {
            get
            {
                return type_dish;
            }

            set
            {
                type_dish = value;
            }
        }
    }
}
