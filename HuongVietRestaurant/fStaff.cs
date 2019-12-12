using HuongVietRestaurant.DAO;
using HuongVietRestaurant.DTO;
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

        BindingSource listtypedish = new BindingSource();

        BindingSource listemployee = new BindingSource();

        BindingSource listbill = new BindingSource();

        public fStaff(string user)
        {
            InitializeComponent();
            lbName.Text = user;
            LoadListDish(null, user);
            LoadListTypeDish(cbbType_Dish1, cbbType_Dish2);
            LoadTypeDish();
            LoadListEmployee();
            LoadBill();
            LoadListStatus(cbb_status_bill);
            dtgvList_Dish.DataSource = listdish;
            dtgrv_type_dish.DataSource = listtypedish;
            dtgv_employee.DataSource = listemployee;
            dtgv_bill.DataSource = listbill;
            AddDishBiding();
            AddTypeDishBiding();
            AddEmployeeBiding();
            AddBillBiding();
        }

        void LoadTypeDish()
        {
            listtypedish.DataSource = TypeDishDAO.Instance.GetTypeDish();
        }

        void LoadBill()
        {
            listbill.DataSource = BillDAO.Instance.GetBill();
        }

        void LoadListDish(string id_type, string user)
        {
            listdish.DataSource = DishDAO.Instance.GetListDish(id_type, user);
        }

        void LoadListDishByIDType(string user, string id_type_dish)
        {
            dtgvList_Dish.DataSource = DishDAO.Instance.GetListDishByIDType(user, id_type_dish);
        }

        void LoadListTypeDish(ComboBox a, ComboBox b)
        {
            a.DataSource = TypeDishDAO.Instance.GetListTypeDish();
            a.DisplayMember = "type_dish_name";

            b.DataSource = TypeDishDAO.Instance.GetListTypeDish();
            b.DisplayMember = "type_dish_name";
        }

        void LoadListStatus(ComboBox a)
        {
            a.DataSource = StatusDAO.Instance.GetStatus();
            a.DisplayMember = "description";
        }

        void LoadListEmployee()
        {
            listemployee.DataSource = EmployeeDAO.Instance.GetListEmployee();
        }

        void AddDishBiding()
        {
            tbID_Dish.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "id_dish"));
            tbName_Dish.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "dish_name"));
            tbPrice.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "price"));
            tbImage.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "image"));
            //nmudNumber.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "unit"));
            lb_name_agency.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "agency_name"));
            lb_id_agency.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "id_agency"));
        }

        void AddTypeDishBiding()
        {
            tb_id_type_dish.DataBindings.Add(new Binding("Text", dtgrv_type_dish.DataSource, "id_type_dish"));
            tb_name_type_dish.DataBindings.Add(new Binding("Text", dtgrv_type_dish.DataSource, "type_dish_name"));
        }

        void AddEmployeeBiding()
        {
            tb_id_em.DataBindings.Add(new Binding("Text", dtgv_employee.DataSource, "id_employee"));
            tb_email_em.DataBindings.Add(new Binding("Text", dtgv_employee.DataSource, "gmail"));
            tb_cart_em.DataBindings.Add(new Binding("Text", dtgv_employee.DataSource, "id_card"));
            tb_city_em.DataBindings.Add(new Binding("Text", dtgv_employee.DataSource, "city"));
            tb_district_em.DataBindings.Add(new Binding("Text", dtgv_employee.DataSource, "district"));
            tb_name_em.DataBindings.Add(new Binding("Text", dtgv_employee.DataSource, "name"));
            tb_block_em.DataBindings.Add(new Binding("Text", dtgv_employee.DataSource, "ward"));
            tb_adress_em.DataBindings.Add(new Binding("Text", dtgv_employee.DataSource, "number_street"));
        }

        void AddBillBiding()
        {
            tb_id_bill.DataBindings.Add(new Binding("Text", dtgv_bill.DataSource, "id_bill"));
        }

        private void btAdd_Dish_Click(object sender, EventArgs e)
        {
            string dish_name = tbName_Dish.Text;
            int price = int.Parse(tbPrice.Text);
            string id_type_dish = (cbbType_Dish2.SelectedItem as TypeDish).Id_type_dish;
            string image = tbImage.Text;
            string id_dish = tbID_Dish.Text;

            if(DishDAO.Instance.AddDish(id_dish, id_type_dish, dish_name, price, image))
            {
                MessageBox.Show("Thêm món thành công.");
                LoadListDish(null, lbName.Text);
            }
            else
            {
                MessageBox.Show("Thêm món thất bại, vui lòng kiểm tra lại.");
            }
        }

        private void btDel_Dish_Click(object sender, EventArgs e)
        {
            string id_dish = tbID_Dish.Text;

            if (DishDAO.Instance.DeleteDish(id_dish))
            {
                MessageBox.Show("Xóa món thành công.");
                LoadListDish(null, lbName.Text);
            }
            else
            {
                MessageBox.Show("Xóa món thất bại, vui lòng kiểm tra lại.");
            }
        }

        private void btEditPrice_Click(object sender, EventArgs e)
        {
            string id_dish = tbID_Dish.Text;
            int price = int.Parse(tbPrice.Text);

            if (DishDAO.Instance.UpdatePriceDish(id_dish, price))
            {
                MessageBox.Show("Sửa món thành công.");
                LoadListDish(null, lbName.Text);
            }
            else
            {
                MessageBox.Show("Sửa món thất bại, vui lòng kiểm tra lại.");
            }
        }

        private void btEditImage_Click(object sender, EventArgs e)
        {
            string id_dish = tbID_Dish.Text;
            string image = tbImage.Text;

            if (DishDAO.Instance.UpdateImageDish(id_dish, image))
            {
                MessageBox.Show("Sửa món thành công.");
                LoadListDish(null, lbName.Text);
            }
            else
            {
                MessageBox.Show("Sửa món thất bại, vui lòng kiểm tra lại.");
            }
        }

        private void btFind_Click(object sender, EventArgs e)
        {
            string name = lbName.Text;

            string id_type_dish = (cbbType_Dish2.SelectedItem as TypeDish).Id_type_dish;

            LoadListDish(id_type_dish, name);

        }

        

        /*private void btEditUnit_Click(object sender, EventArgs e)
        {
            string id_dish = tbID_Dish.Text;
            string id_agency= dtgvList_Dish.SelectedCells[0].OwningRow.Cells["id_agency"].Value.ToString();
            int unit = int.Parse(nmudNumber.Value.ToString());

            if (DishDAO.Instance.UpdateUnitDish(id_dish, id_agency, unit))
            {
                MessageBox.Show("Sửa món thành công.");
                LoadListDish(lbName.Text);
            }
            else
            {
                MessageBox.Show("Sửa món thất bại, vui lòng kiểm tra lại.");
            }
        }*/

        private void btEditNameDish_Click(object sender, EventArgs e)
        {
            string id_dish = tbID_Dish.Text;
            string name = tbName_Dish.Text;

            if (DishDAO.Instance.UpdateNameDish(id_dish, name))
            {
                MessageBox.Show("Sửa món thành công.");
                LoadListDish(null, lbName.Text);
            }
            else
            {
                MessageBox.Show("Sửa món thất bại, vui lòng kiểm tra lại.");
            }
        }

        //erro
        private void btEditTypeDish_Click(object sender, EventArgs e)
        {
            string id_dish = tbID_Dish.Text;

            string id_type_dish = (cbbType_Dish2.SelectedItem as TypeDish).Id_type_dish;

            if (DishDAO.Instance.UpdateTypeDish(id_dish, id_type_dish))
            {
                MessageBox.Show("Sửa món thành công.");
                LoadListDish(null, lbName.Text);
            }
            else
            {
                MessageBox.Show("Sửa món thất bại, vui lòng kiểm tra lại.");
            }
        }

        private void bt_Del_type_dish_Click(object sender, EventArgs e)
        {
            string id_type_dish = tb_id_type_dish.Text;

            if (TypeDishDAO.Instance.DelTypeDish(id_type_dish))
            {
                MessageBox.Show("Xóa loại món ăn thành công.");
                LoadTypeDish();
            }
            else
            {
                MessageBox.Show("Xóa thất bại, vui lòng kiểm tra lại.");
            }
        }

        private void bt_edit_email_em_Click(object sender, EventArgs e)
        {
            string id = tb_id_em.Text;
            string gmail = tb_email_em.Text;

            if (EmployeeDAO.Instance.UpdateGmailEm(id, gmail))
            {
                MessageBox.Show("Sửa gmail nhân viên thành công.");
                LoadListEmployee();
            }
            else
            {
                MessageBox.Show("Sửa thất bại, vui lòng kiểm tra lại.");
            }
        }

        private void bt_edit_name_em_Click(object sender, EventArgs e)
        {
            string id = tb_id_em.Text;
            string name = tb_name_em.Text;

            if (EmployeeDAO.Instance.UpdateNameEm(id, name))
            {
                MessageBox.Show("Sửa tên nhân viên thành công.");
                LoadListEmployee();
            }
            else
            {
                MessageBox.Show("Sửa thất bại, vui lòng kiểm tra lại.");
            }
        }

        private void tbID_Dish_TextChanged(object sender, EventArgs e)
        {
            if (dtgvList_Dish.SelectedCells.Count > 0)
            {
                string id = dtgvList_Dish.SelectedCells[0].OwningRow.Cells["id_type_dish"].Value.ToString();

                TypeDish type = TypeDishDAO.Instance.GetTypeDishByID(id);

                cbbType_Dish2.SelectedItem = type;

                int index = -1;
                int i = 0;

                foreach (TypeDish item in cbbType_Dish2.Items)
                {
                    if (item.Id_type_dish == type.Id_type_dish)
                    {
                        index = i;
                        break;
                    }
                    i++;
                }

                cbbType_Dish2.SelectedIndex = index;
            }
        }

        private void tb_id_bill_TextChanged(object sender, EventArgs e)
        {
            if (dtgv_bill.SelectedCells.Count > 0)
            {
                string id = dtgv_bill.SelectedCells[0].OwningRow.Cells["status"].Value.ToString();

                Status type = StatusDAO.Instance.GetStatusByID(id);

                cbb_status_bill.SelectedItem = type;

                int index = -1;
                int i = 0;

                foreach (Status item in cbb_status_bill.Items)
                {
                    if (item.Id_status == type.Id_status)
                    {
                        index = i;
                        break;
                    }
                    i++;
                }

                cbb_status_bill.SelectedIndex = index;
            }
        }
    }
}
