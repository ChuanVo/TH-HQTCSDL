namespace HuongVietRestaurant
{
    partial class fCustomer
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.panel1 = new System.Windows.Forms.Panel();
            this.flpMenu = new System.Windows.Forms.FlowLayoutPanel();
            this.panelInfo = new System.Windows.Forms.Panel();
            this.txtFoodName = new System.Windows.Forms.TextBox();
            this.btnAddToCart = new System.Windows.Forms.Button();
            this.numericUpDown1 = new System.Windows.Forms.NumericUpDown();
            this.txtFoodInfo = new System.Windows.Forms.TextBox();
            this.ptbFood = new System.Windows.Forms.PictureBox();
            this.panel2 = new System.Windows.Forms.Panel();
            this.btnViewLess50 = new System.Windows.Forms.Button();
            this.btnViewEnableFood = new System.Windows.Forms.Button();
            this.btnCart = new System.Windows.Forms.Button();
            this.cboCategory = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.cboAgency = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.panel1.SuspendLayout();
            this.panelInfo.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDown1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.ptbFood)).BeginInit();
            this.panel2.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.flpMenu);
            this.panel1.Controls.Add(this.panelInfo);
            this.panel1.Controls.Add(this.panel2);
            this.panel1.Location = new System.Drawing.Point(4, 1);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(781, 571);
            this.panel1.TabIndex = 0;
            // 
            // flpMenu
            // 
            this.flpMenu.AutoScroll = true;
            this.flpMenu.Location = new System.Drawing.Point(8, 93);
            this.flpMenu.Name = "flpMenu";
            this.flpMenu.Size = new System.Drawing.Size(420, 478);
            this.flpMenu.TabIndex = 0;
            // 
            // panelInfo
            // 
            this.panelInfo.Controls.Add(this.txtFoodName);
            this.panelInfo.Controls.Add(this.btnAddToCart);
            this.panelInfo.Controls.Add(this.numericUpDown1);
            this.panelInfo.Controls.Add(this.txtFoodInfo);
            this.panelInfo.Controls.Add(this.ptbFood);
            this.panelInfo.Location = new System.Drawing.Point(434, 93);
            this.panelInfo.Name = "panelInfo";
            this.panelInfo.Size = new System.Drawing.Size(340, 478);
            this.panelInfo.TabIndex = 1;
            // 
            // txtFoodName
            // 
            this.txtFoodName.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.txtFoodName.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtFoodName.Location = new System.Drawing.Point(22, 189);
            this.txtFoodName.Name = "txtFoodName";
            this.txtFoodName.ReadOnly = true;
            this.txtFoodName.Size = new System.Drawing.Size(302, 23);
            this.txtFoodName.TabIndex = 6;
            this.txtFoodName.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // btnAddToCart
            // 
            this.btnAddToCart.BackColor = System.Drawing.SystemColors.Control;
            this.btnAddToCart.FlatStyle = System.Windows.Forms.FlatStyle.Popup;
            this.btnAddToCart.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnAddToCart.Location = new System.Drawing.Point(164, 387);
            this.btnAddToCart.Name = "btnAddToCart";
            this.btnAddToCart.Size = new System.Drawing.Size(162, 82);
            this.btnAddToCart.TabIndex = 5;
            this.btnAddToCart.Text = "Add to Cart";
            this.btnAddToCart.UseVisualStyleBackColor = false;
            this.btnAddToCart.Click += new System.EventHandler(this.btnAddToCart_Click);
            // 
            // numericUpDown1
            // 
            this.numericUpDown1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.numericUpDown1.Location = new System.Drawing.Point(37, 418);
            this.numericUpDown1.Minimum = new decimal(new int[] {
            100,
            0,
            0,
            -2147483648});
            this.numericUpDown1.Name = "numericUpDown1";
            this.numericUpDown1.Size = new System.Drawing.Size(110, 27);
            this.numericUpDown1.TabIndex = 3;
            this.numericUpDown1.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // txtFoodInfo
            // 
            this.txtFoodInfo.BackColor = System.Drawing.Color.White;
            this.txtFoodInfo.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtFoodInfo.Location = new System.Drawing.Point(22, 227);
            this.txtFoodInfo.Multiline = true;
            this.txtFoodInfo.Name = "txtFoodInfo";
            this.txtFoodInfo.ReadOnly = true;
            this.txtFoodInfo.Size = new System.Drawing.Size(302, 146);
            this.txtFoodInfo.TabIndex = 2;
            // 
            // ptbFood
            // 
            this.ptbFood.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.ptbFood.Location = new System.Drawing.Point(91, 13);
            this.ptbFood.Name = "ptbFood";
            this.ptbFood.Size = new System.Drawing.Size(166, 165);
            this.ptbFood.TabIndex = 0;
            this.ptbFood.TabStop = false;
            this.ptbFood.Click += new System.EventHandler(this.ptbFood_Click);
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.btnViewLess50);
            this.panel2.Controls.Add(this.btnViewEnableFood);
            this.panel2.Controls.Add(this.btnCart);
            this.panel2.Controls.Add(this.cboCategory);
            this.panel2.Controls.Add(this.label2);
            this.panel2.Controls.Add(this.cboAgency);
            this.panel2.Controls.Add(this.label1);
            this.panel2.Location = new System.Drawing.Point(6, 7);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(769, 85);
            this.panel2.TabIndex = 0;
            // 
            // btnViewLess50
            // 
            this.btnViewLess50.Enabled = false;
            this.btnViewLess50.Location = new System.Drawing.Point(436, 48);
            this.btnViewLess50.Name = "btnViewLess50";
            this.btnViewLess50.Size = new System.Drawing.Size(159, 25);
            this.btnViewLess50.TabIndex = 8;
            this.btnViewLess50.Text = "View Price < 50k";
            this.btnViewLess50.UseVisualStyleBackColor = true;
            this.btnViewLess50.Click += new System.EventHandler(this.button1_Click_1);
            // 
            // btnViewEnableFood
            // 
            this.btnViewEnableFood.Enabled = false;
            this.btnViewEnableFood.Location = new System.Drawing.Point(436, 14);
            this.btnViewEnableFood.Name = "btnViewEnableFood";
            this.btnViewEnableFood.Size = new System.Drawing.Size(159, 25);
            this.btnViewEnableFood.TabIndex = 7;
            this.btnViewEnableFood.Text = "View Unit > 0";
            this.btnViewEnableFood.UseVisualStyleBackColor = true;
            this.btnViewEnableFood.Click += new System.EventHandler(this.button1_Click);
            // 
            // btnCart
            // 
            this.btnCart.Enabled = false;
            this.btnCart.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnCart.Location = new System.Drawing.Point(606, 0);
            this.btnCart.Name = "btnCart";
            this.btnCart.Size = new System.Drawing.Size(146, 82);
            this.btnCart.TabIndex = 4;
            this.btnCart.Text = "VIEW CART";
            this.btnCart.UseVisualStyleBackColor = true;
            this.btnCart.Click += new System.EventHandler(this.btnCart_Click);
            // 
            // cboCategory
            // 
            this.cboCategory.Enabled = false;
            this.cboCategory.FormattingEnabled = true;
            this.cboCategory.Location = new System.Drawing.Point(188, 48);
            this.cboCategory.Name = "cboCategory";
            this.cboCategory.Size = new System.Drawing.Size(234, 24);
            this.cboCategory.TabIndex = 3;
            this.cboCategory.DropDown += new System.EventHandler(this.cboCategory_DropDown);
            this.cboCategory.SelectedIndexChanged += new System.EventHandler(this.cboCategory_SelectedIndexChanged);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(13, 47);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(158, 24);
            this.label2.TabIndex = 2;
            this.label2.Text = "Choose category:";
            // 
            // cboAgency
            // 
            this.cboAgency.FormattingEnabled = true;
            this.cboAgency.Location = new System.Drawing.Point(188, 13);
            this.cboAgency.Name = "cboAgency";
            this.cboAgency.Size = new System.Drawing.Size(234, 24);
            this.cboAgency.TabIndex = 1;
            this.cboAgency.DropDown += new System.EventHandler(this.cboAgency_DropDown);
            this.cboAgency.SelectedIndexChanged += new System.EventHandler(this.cboAgency_SelectedIndexChanged);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(13, 14);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(148, 24);
            this.label1.TabIndex = 0;
            this.label1.Text = "Choose agency:";
            // 
            // fCustomer
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(786, 576);
            this.Controls.Add(this.panel1);
            this.Name = "fCustomer";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Order - Huong Viet Restaurant";
            this.Load += new System.EventHandler(this.fCustomer_Load);
            this.panel1.ResumeLayout(false);
            this.panelInfo.ResumeLayout(false);
            this.panelInfo.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDown1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.ptbFood)).EndInit();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.ComboBox cboAgency;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button btnCart;
        private System.Windows.Forms.ComboBox cboCategory;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.FlowLayoutPanel flpMenu;
        private System.Windows.Forms.Panel panelInfo;
        private System.Windows.Forms.TextBox txtFoodInfo;
        private System.Windows.Forms.PictureBox ptbFood;
        private System.Windows.Forms.Button btnAddToCart;
        private System.Windows.Forms.NumericUpDown numericUpDown1;
        private System.Windows.Forms.TextBox txtFoodName;
        private System.Windows.Forms.Button btnViewEnableFood;
        private System.Windows.Forms.Button btnViewLess50;
    }
}