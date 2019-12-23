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

        BindingSource listmenudish = new BindingSource();

        BindingSource listmenu = new BindingSource();

        BindingSource listmenu_pay = new BindingSource();

        public fStaff(string user)
        {
            InitializeComponent();

            lbName.Text = user;

            LoadListDish(null, user);
            LoadListTypeDish(cbbType_Dish1, cbbType_Dish2);
            LoadTypeDish();
            LoadMenuPay();

            dtgvList_Dish.DataSource = listdish;
            dtgrv_type_dish.DataSource = listtypedish;
            dtgv_employee.DataSource = listemployee;
            dtgv_bill.DataSource = listbill;
            dtgv_Menu_Dish.DataSource = listmenudish;
            dtgv_Menu.DataSource = listmenu;
            dtgv_tt.DataSource = listmenu_pay;

            AddDishBiding();
            AddTypeDishBiding();
            AddPayBiding();
        }

        void LoadTypeDish()
        {
            listtypedish.DataSource = TypeDishDAO.Instance.GetTypeDish();
        }

        void LoadBill()
        {
            string agency = lb_id_agency.Text;

            listbill.DataSource = BillDAO.Instance.GetBill(agency);
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

        void LoadDishForMenu()
        {
            listmenudish.DataSource = MenuDAO.Instance.GetDish();
        }

        void LoadMenu()
        {
            listmenu.DataSource = MenuDAO.Instance.GetMenu(lbName.Text);
        }

        void LoadMenuPay()
        {
            string user = lbName.Text;

            listmenu_pay.DataSource = PayDAO.Instance.GetMenu(user);
        }

        void LoadListPositon()
        {
            cbb_position_em.DataSource = PositionDAO.Instance.GetPosition();
            cbb_position_em.DisplayMember = "position_name";
        }

        void AddDishBiding()
        {
            tbID_Dish.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "id_dish"));
            tbName_Dish.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "dish_name"));
            tbPrice.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "price"));
            tbImage.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "image"));           
            lb_name_agency.DataBindings.Add(new Binding("Text", dtgvList_Dish.DataSource, "agency_name"));
        }

        void AddTypeDishBiding()
        {
            tb_id_type_dish.DataBindings.Add(new Binding("Text", dtgrv_type_dish.DataSource, "id_type_dish"));
            tb_name_type_dish.DataBindings.Add(new Binding("Text", dtgrv_type_dish.DataSource, "type_dish_name"));
        }

        void AddEmployeeBiding()
        {
            tb_id_em.DataBindings.Clear();
            tb_id_em.DataBindings.Add(new Binding("Text", dtgv_employee.DataSource, "id_employee"));

            tb_email_em.DataBindings.Clear();
            tb_email_em.DataBindings.Add(new Binding("Text", dtgv_employee.DataSource, "gmail"));

            tb_card_em.DataBindings.Clear();
            tb_card_em.DataBindings.Add(new Binding("Text", dtgv_employee.DataSource, "id_card"));

            tb_city_em.DataBindings.Clear();
            tb_city_em.DataBindings.Add(new Binding("Text", dtgv_employee.DataSource, "city"));

            tb_district_em.DataBindings.Clear();
            tb_district_em.DataBindings.Add(new Binding("Text", dtgv_employee.DataSource, "district"));

            tb_name_em.DataBindings.Clear();
            tb_name_em.DataBindings.Add(new Binding("Text", dtgv_employee.DataSource, "name"));

            tb_block_em.DataBindings.Clear();
            tb_block_em.DataBindings.Add(new Binding("Text", dtgv_employee.DataSource, "ward"));

            tb_adress_em.DataBindings.Clear();
            tb_adress_em.DataBindings.Add(new Binding("Text", dtgv_employee.DataSource, "number_street"));
        }

        void AddBillBiding()
        {
            tb_id_bill.DataBindings.Clear();
            tb_id_bill.DataBindings.Add(new Binding("Text", dtgv_bill.DataSource, "id_bill"));
        }

        void AddMenuDishBiding()
        {
            tb_menu_id_dish.DataBindings.Clear();
            tb_menu_id_dish.DataBindings.Add(new Binding("Text", dtgv_Menu_Dish.DataSource, "id_dish"));

            tb_menu_namedish.DataBindings.Clear();
            tb_menu_namedish.DataBindings.Add(new Binding("Text", dtgv_Menu_Dish.DataSource, "dish_name"));
        }

        void AddMenuBiding()
        {
            tb_menu_id.DataBindings.Clear();
            tb_menu_id.DataBindings.Add(new Binding("Text", dtgv_Menu.DataSource, "id_dish"));

            tb_menu_name.DataBindings.Clear();
            tb_menu_name.DataBindings.Add(new Binding("Text", dtgv_Menu.DataSource, "dish_name"));

            nnud_menu_unit.DataBindings.Clear();
            nnud_menu_unit.DataBindings.Add(new Binding("Text", dtgv_Menu.DataSource, "unit"));
        }

        void AddPayBiding()
        {
            tb_tt_id.DataBindings.Add(new Binding("Text", dtgv_tt.DataSource, "id_dish"));
            tb_tt_name.DataBindings.Add(new Binding("Text", dtgv_tt.DataSource, "dish_name"));
            nnud_tt_unit.DataBindings.Add(new Binding("Text", dtgv_tt.DataSource, "unit"));
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
            lb_id_agency.Text = dtgvList_Dish.SelectedCells[0].OwningRow.Cells["id_agency"].Value.ToString();

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

                cbb_bill.SelectedItem = type;

                int index = -1;
                int i = 0;

                foreach (Status item in cbb_bill.Items)
                {
                    if (item.Id_status == type.Id_status)
                    {
                        index = i;
                        break;
                    }
                    i++;
                }

                cbb_bill.SelectedIndex = index;
            }
        }

        private void bt_dis_em_Click(object sender, EventArgs e)
        {
            LoadListEmployee();

            LoadListPositon();

            AddEmployeeBiding();
        }

        private void bt_dis_menu_Click(object sender, EventArgs e)
        {
            LoadMenu();

            AddMenuBiding();
        }

        private void tb_menu_add_Click(object sender, EventArgs e)
        {
            string id_dish = tb_menu_id_dish.Text;
            string id_agency = lb_id_agency.Text;
            int unit = int.Parse(nmudNumber.Value.ToString());

            if (MenuDAO.Instance.AddDishForMenu(id_dish, id_agency, unit))
            {
                MessageBox.Show("Thêm món vào menu thành công.");

                LoadDishForMenu();

                LoadMenu();
            }
            else
            {
                MessageBox.Show("Thêm thất bại, vui lòng kiểm tra lại.");
            }
        }

        private void bt_dis_dish_Click(object sender, EventArgs e)
        {
            LoadDishForMenu();

            AddMenuDishBiding();
        }

        private void btEditUnit_Click_1(object sender, EventArgs e)
        {
            string id_dish = tb_menu_id.Text;
            string id_agency = lb_id_agency.Text;
            int unit = int.Parse(nnud_menu_unit.Value.ToString());
          
            if (MenuDAO.Instance.UpdateUnitDish(id_dish, id_agency, unit))
            {
                MessageBox.Show("Sửa món trong menu thành công.");

                LoadDishForMenu();
            }
            else
            {
                MessageBox.Show("Sửa thất bại, vui lòng kiểm tra lại.");
            }
        }

        private void bt_add_em_Click(object sender, EventArgs e)
        {
            string id = tb_id_em.Text;
            string name = tb_name_em.Text;
            string email = tb_email_em.Text;
            string card = tb_card_em.Text;
            string pos = cbb_position_em.Text;
            string address = tb_adress_em.Text;
            string ward = tb_block_em.Text;
            string district = tb_district_em.Text;
            string city = tb_city_em.Text;
            string agency = lb_id_agency.Text;

            if (EmployeeDAO.Instance.AddEm(id, name, email, card, pos, address, ward, district, city, agency))
            {
                MessageBox.Show("Thêm thành công.");

                LoadListEmployee();
            }
            else
            {
                MessageBox.Show("Thêm thất bại, vui lòng kiểm tra lại.");
            }
        }

        private void bt_edit_status_Click(object sender, EventArgs e)
        {
            string id = tb_id_bill.Text;

            string agency = lb_id_agency.Text;

            string status = (cbb_bill.SelectedItem as Status).Id_status;

            if (BillDAO.Instance.UpdateBillStatus(id, agency, status))
            {
                MessageBox.Show("Sửa thành công.");

                LoadBill();
            }
            else
            {
                MessageBox.Show("Sửa thất bại, vui lòng kiểm tra lại.");
            }
        }

        private void tctAdmin_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void dtgvList_Dish_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void bt_tt_Click(object sender, EventArgs e)
        {
            string id = tb_tt_id.Text;
            string agency = lb_id_agency.Text;
            int unit = int.Parse(nnud_tt_unit.Value.ToString());

            if (PayDAO.Instance.PayDish(id, agency, unit))
            {
                MessageBox.Show("Thanh toán thành công.");

                LoadMenuPay();
            }
            else
            {
                MessageBox.Show("Thanh toán thất bại, vui lòng kiểm tra lại.");
            }
        }

        private void bt_dis_bill_Click(object sender, EventArgs e)
        {
            LoadBill();

            LoadListStatus(cbb_bill);

            AddBillBiding();
        }
    }
}
