using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DTO
{
    class TypeDish
    {
        public TypeDish (string type_dish_name, string id_type_dish)
        {
            this.Type_dish_name = type_dish_name;
            this.Id_type_dish = id_type_dish;
        }

        public TypeDish (DataRow row)
        {
            this.Type_dish_name = row["type_dish_name"].ToString();
            this.Id_type_dish = row["id_type_dish"].ToString();
        }

        private string type_dish_name;

        private string id_type_dish;


        public string Id_type_dish
        {
            get
            {
                return id_type_dish;
            }

            set
            {
                id_type_dish = value;
            }
        }

        public string Type_dish_name
        {
            get
            {
                return type_dish_name;
            }

            set
            {
                type_dish_name = value;
            }
        }
    }
}
