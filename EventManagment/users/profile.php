<!DOCTYPE html>
<html lang="en">
<head>
  <title>Profile</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

  <link href="https://fonts.googleapis.com/css?family=Montserrat" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Lato" rel="stylesheet" type="text/css">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
 
  
</head>
<body style = "background: white">


  
    <header class="homepage"style="font-family:'Montserrat', sans-serif;" >
      
        <nav id="navbar" class="navbar navbar-default navbar-fixed-top">
        <div class="navbar-header" >
             EVENT MANAGEMENT
             </div>  <ul style="margin-top:10px;">
                    <li><a href="index.php">HOME</a></li>
                    <li><a href="profile.php">PROFILE</a></li>
                    <li><a href="venue.php">BOOK A VENUE</a></li>
                    <li><a href="../login.php">LOGOUT</a></li>
                    </ul>
                    
                    </nav>
      </header>
      
<?php include('../log1.php'); ?>
<?php
    // header("refresh: 3;");
?>
        
  <div class="container">
  <div class="card m-auto" style="width:400px">
    <h4 class="card-title">Welcome <?php echo $_SESSION['name'];?></h4>
    <img class="card-img-top m-auto" src="images/avtar.jpg" alt="Card image" style="width:100px; height: 100px; padding: 10px; border-radius:50%;">
    <div class="card-body">
      
      <p> <b>Name:  </b><?php echo $_SESSION['name'];?> <hr> </p>
      <p> <b>Email:  </b><?php echo $_SESSION['email'];?> <hr> </p>
      <p> <b>Contact:  </b><?php echo $_SESSION['phone_no'];?> <hr> </p>
      <a href="editprofile.php" class="btn btn-primary">Edit profile</a>
    </div>
  </div>
  <br>  
</div>
<center>

        <div class="panel-body">
                
          <table class="table table-striped table-hover">
            <tr>
            <th class="center-align">#</th>
            <th class="center-align">Event Type</th>
            <th class="center-align">Venue Type</th>
            <th class="center-align">Venue Address</th>  
            <th class="center-align">Date</th> 
            <th class="center-align">Audience Size</th>
            <th class="center-align">Equipments 
            <br>(recommended values)</th>  
            <th class="center-align">Total cost</th>
            <th class="center-align">Action</th>
            </tr>
        <?php 
        $i=1;
        $link = mysqli_connect('localhost', 'root', '');
        mysqli_select_db($link, "user_info");
        $sql="SELECT * from `venue_booking` where `user_phone` ='".$_SESSION['phone_no']."' ";
        $sql_event_name = "SELECT `name` FROM `event` e, `venue_booking` v where e.id = v.event_id and v.user_phone = ".$_SESSION['phone_no']."  ";
        $res = mysqli_query ($link, $sql);
        $res_event_name = mysqli_query($link, $sql_event_name);
        $sql_venue = "SELECT * FROM `venue` v, `venue_booking` vb where v.id = vb.venue_id and vb.user_phone = ".$_SESSION['phone_no']."  ";
        $res_venue = mysqli_query($link, $sql_venue);
        $sql_equipments = "SELECT * FROM `equipments` e, `venue_booking` vb where e.venue_booking_id = vb.id and vb.user_phone = ".$_SESSION['phone_no']."  ";
        $res_equipments = mysqli_query($link, $sql_equipments);
        while($row = mysqli_fetch_array($res) 
        and $row_event_name = mysqli_fetch_array($res_event_name)
         and $row_venue = mysqli_fetch_array($res_venue) 
         and $row_equipments = mysqli_fetch_array($res_equipments) 
         )
        { 
          $equip_id="";
        echo "<tr>";
          //  echo "<td>"; echo $row["user_name"]; echo" </td>";
          //  echo "<td>"; echo $row["user_phone"]; echo" </td>";
          echo "<td>"; echo $i++; echo" </td>";
           echo "<td>"; echo $row_event_name["name"]; echo" </td>";
           echo "<td>"; echo $row_venue["name"]; echo" </td>";
           echo "<td>"; echo $row_venue["address"]; echo" </td>";
           echo "<td>"; echo $row["date"]; echo" </td>";
           echo "<td>"; echo $row["audience_size"]; echo" </td>";
           echo "<td>"; echo "
           <p>
             <option value='1'> Chairs:"; echo $row_equipments['chairs_no'] ; echo " </option>
             <option value='2'> Tables:"; echo $row_equipments["tables_no"]; echo"</option>                  
             <option value='3'> Lights:"; echo $row_equipments["lights_no"]; echo"</option>                    
             <option value='4'> Speakers:"; echo $row_equipments["speakers_no"]; echo"</option>                    
             <option value='5'> Microphones:"; echo $row_equipments["microphones_no"]; echo"</option>               
           </p>  ";
          
           $equip_id =  $row_equipments["eid"];
           
           echo "<p><a href = 'edit_equipments.php?id= $equip_id'>"; echo "<button type='submit'>Edit</button></p>";
          //   $rate = ($row_equipments["chairs_no"] + $row_equipments["tables_no"] + $row_equipments["lights_no"] + $row_equipments["speakers_no"] + $row_equipments["microphones_no"]) * 10 + $row_venue["rate"];
          //  echo "<td>"; echo $rate; echo" </td>";
          $id = $row["id"]; 
            $sql_eq = "SELECT * FROM `equipments` where `venue_booking_id` = '$id'";
            $res_eq = mysqli_query($data, $sql_eq);
            $row_eq = mysqli_fetch_array($res_eq);
            $vd = $row_eq["venue_booking_id"];
            $query = "SELECT calculate_total_cost($vd) AS total_cost";
            $res_r = mysqli_query($data, $query);
            if ($res_r) {
              $row = mysqli_fetch_assoc($res_r);
              $total_cost = $row['total_cost'];
              echo "<td> $total_cost </td>";
          } else {
              echo "Error executing query: " . mysqli_error($data);
          }
      
           echo "<td> "; echo "<p><a href = 'delete.php?id= $id'>"; echo "<button type='submit'>Cancel</button></p>";
           echo "<p><a href = 'receipt.php?id= $id' >"; echo "<button type='submit'>Receipt</button></p>";
            echo "</td>";
        echo "</tr>";
        }
        
        ?>
        </table>
              </div>
     
</body>

<style>
  body{
    background-color:#B1D0E0;
    /* background: rgba(0,0,0,0.6); */
  }
  
    .card-title {
    margin-bottom: 0.5rem;
    color: black;
    text-align: center;
}
.card{
  padding: 10px;
  border-radius:20px;
  background-color: rgba(255, 255, 255,0.5);
  border-color: #4b3181;
}
button{
    color: #fff;
    background-color: #4b3181;
    border-color: #4b3181;
    border-radius:5px;
}
button:hover{
  color: #fff;
    background-color: #052d67;
    border-color: #052d67;
}
.container {
    margin-top: 6rem !important ;
}
 #navbar{
    background:#4b3181;
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin: auto;
    padding: 0 30px;
    width: 100%;
    top:0;
    position: fixed;
    height: 50px;
    z-index: 2;
}
#navbar ul{
    display: flex;
    list-style: none;
}
#navbar ul a{
margin-right: 80px;
padding: 20px;
color: #fff;
text-decoration: none;    
}
#navbar ul a:hover{
    background: white;
    color:#4b3181;
}
table{
  margin: 20px;
  display: inline;
  /* background-color: rgba(255, 255, 255, 1) !important; */

}
.center-align {
    text-align: center;
}

.table>:not(caption)>*>* {
    padding: 0.5rem 0.5rem;
    background-color: white !important;
    border-bottom-width: 1px;
    box-shadow: inset 0 0 0 9999px var(--bs-table-accent-bg);
}
</style>
</html>
