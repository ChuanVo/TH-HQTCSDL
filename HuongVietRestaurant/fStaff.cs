using HuongVietRestaurant.DAO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace HuongVietRestaurant
{
    public partial class fStaff : Form
    {
        BindingSource listdish = new BindingSource();

        public fStaff()
        {
            InitializeComponent();
            LoadListDish();
            LoadListTypeDish();
            dtgvList_Dish.DataSource = listdish;
            AddDishBiding();
        }

        void LoadListDish()
        {
            listdish.DataSource = DishDAO.Instance.GetListDish();
        }

        void LoadListTypeDish()
        {
            cbbType_Dish1.DataSource = TypeDishDAO.Instance.GetListTypeDish();
            cbbType_Dish1.DisplayMember = "type_dish_name";

            cbbType_Dish2.DataSource = TypeDishDAO.Instance.GetListTypeDish();
            cbbType_Dish2.DisplayMember = "type_dish_name";
        }

        void AddDishBiding()
        {
            tbID_Dish.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "id_dish"));
            tbName_Dish.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "dish_name"));
            tbPrice.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "price"));
            tbImage.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "image"));
            cbbType_Dish2.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "type_dish_name"));
            nmudNumber.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "unit"));
        }

        private void btLoad_Click(object sender, EventArgs e)
        {
            LoadListDish();
        }

        private void btAdd_Dish_Click(object sender, EventArgs e)
        {
            string dish_name = tbName_Dish.Text;
            int price = int.Parse(tbPrice.Text);
            string type_dish = cbbType_Dish2.Text;
            string image = tbImage.Text;
            int unit = (int)nmudNumber.Value;
            string agency = tbAgency.Text;
            string id_dish = tbID_Dish.Text;

            if(DishDAO.Instance.AddDish(id_dish, type_dish, dish_name, price, image, unit, agency))
            {
                MessageBox.Show("Thêm món thành công.");
                LoadListDish();
            }
            else
            {
                MessageBox.Show("Thêm món thất bại, vui lòng kiểm tra lại.");
            }
        }

        private void btEdit_Dish_Click(object sender, EventArgs e)
        {
            string dish_name = tbName_Dish.Text;
            int price = int.Parse(tbPrice.Text);
            string type_dish = cbbType_Dish2.Text;
            string image = tbImage.Text;
            int unit = (int)nmudNumber.Value;
            string id_dish = tbID_Dish.Text;

            if (DishDAO.Instance.UpdateDish(id_dish, type_dish, dish_name, price, image, unit))
            {
                MessageBox.Show("Sưa món thành công.");
                LoadListDish();
            }
            else
            {
                MessageBox.Show("Sửa món thất bại, vui lòng kiểm tra lại.");
            }
        }

        private void btDel_Dish_Click(object sender, EventArgs e)
        {
            string id_dish = tbID_Dish.Text;

            if (DishDAO.Instance.DeleteDish(id_dish))
            {
                MessageBox.Show("Xóa món thành công.");
                LoadListDish();
            }
            else
            {
                MessageBox.Show("Xóa món thất bại, vui lòng kiểm tra lại.");
            }
        }
    }
}
