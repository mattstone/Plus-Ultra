class Admin::DashboardController < Admin::BaseController
  
  def index 
    
    @start_date = Time.now - 1.year 
    @end_date   = Time.now

    @user_sign_ups_confirmed = User 
                       .where(confirmed_at: @start_date..@end_date)
                       .group_by_day(:created_at)
                       .count 
                       
    @user_sign_ups_abandoned = User 
                       .where(confirmed_at: nil)
                       .group_by_day(:created_at)
                       .count 
                                              
    @line_chart_users = [
      { name: "Confirmed", data: @user_sign_ups_confirmed },
      { name: "Abandoned", data: @user_sign_ups_abandoned }
    ]

    @sales_cleared_funds = Transaction 
                .where(status: "cleared_funds")
                .where(created_at: @start_date..@end_date)
                .group_by_day(:created_at)
                .count 
                                      
    @sales_failed = Transaction 
                .where(status: "failed")
                .where(created_at: @start_date..@end_date)
                .group_by_day(:created_at)
                .count 
                
                       
    @sales_processing = Transaction 
                .where(status: "processing")
                .where(created_at: @start_date..@end_date)
                .group_by_day(:created_at)
                .count 
    
    @line_chart_sales = [
      { name: "Cleared Funds", data: @sales_cleared_funds },
      { name: "Failed",        data: @sales_failed        },
      { name: "Processing",   data: @sales_processing     }
    ]
    
  end 
  
  def logout
    log_out_current_user
  end
    
end
