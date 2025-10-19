const domain = 'https://captain-drive.webbing-agency.com/api/';
const LOGIN = 'user/login';
const SIGNIN = 'driver/login';
const REGISTER = 'user/register';
const SIGNUP = 'driver/register';
const FORGET_PASSWORD = 'driver/forgot-password';
const CATEGORIES = 'categories/get';
const SIGNOUT = 'driver/logout';
const CHECK_MAIL = 'driver/forgot-password-check-code';
const CREATE_NEW_PASSWORD = 'driver/forgot-password-set';
const CHANGE_PASSWORD = 'driver/change-password';
const GET_CAPTAIN_DATA = 'driver';
const GET_CAPTAIN_ACTIVITIES = 'activities/rides/driver';
const GET_CAPTAIN_REQUESTS = 'offer/driver/show-near-requests';
const CAPTAIN_MAKE_OFFER = 'offer/driver/make-offer';
const CAPTAIN_Cancel_OFFER = 'ride/cancel-ride/driver';
const CAPTAIN_RIDE_Cancel_OFFER = 'offer/driver/cancel-offer';
const CAPTAIN_GET_RESERVATION = 'reservation/driver/show-near-reservations';
const CAPTAIN_GET_DRIVER_RESERVATION = 'reservation/driver/get';
const CAPTAIN_MAKE_RESERVATION_OFFER =
    'reservation/driver/make-reservation-offer';
const CAPTAIN_Cancel_RESERVATION_OFFER =
    'reservation/driver/cancel-reservaton-offer';
const SET_CURRENT_LOACTION = 'driver/set-location';
const GET_RESERVATION_OFFER = 'reservation/driver/get-reservation/offers';
const GET_RIDE_OFFER = 'offer/driver/get-offer';
const GET_ACTIVE_RIDE = 'ride/get-ride/driver';
const GET_MEssage = 'driver/message';
const Delete_DRIVER = 'driver/rejected';
const DriverStatus = 'driver/set-status';
const VIEDO = 'video';
const SETCompleteRIDE = 'ride/set-completed/driver';
const SETARRIVERIDE = 'ride/set-arrived/driver';
const CANECEL = 'reservation/driver/cancel';
const ARRIVE = 'reservation/driver/set-arriving';

const PRODUCTSBYCATEGORIES = 'products/get-products-per-category-all';

const PRODUCTSSEARCH =
    'products/get-products-search?sort=LP&per_page=2&page=1&';

const ORDERSEARCH = 'orders/user/search/all';
const imageDomain =
    'https://captain-drive.webbing-agency.com/storage/app/public/';

//orders/user/search/all

const FAVORITES = 'wishlist/add-or-remove-product';

const GETFAVORITES = 'wishlist/get';

const GETUSER = 'user';

const GETHOME = 'home/load-data';

const GETCART = 'cart/get';

const GETORDER = 'orders/user/all';

const GETTRANSACTION = 'transactions/user/all';

const REMOVECART = 'cart/remove-product';

const ADDECART = 'cart/put-product';

const UPDATEPRODUCTQUANTITYCART = 'cart/update-product-quantity';

const PLACEORDER = 'orders/place';

const WITHDRAWREQUEST = 'orders/user/request/withdraw';

const CHANGEPASSWORD = 'user/change-password';

const FORGETPASSWORD = 'user/forgot-password';

const CHECKPASSWORD = 'user/forgot-password-check-code';

const CREATENEWPASSWORD = 'user/forgot-password-set';

const UPDATE = 'user/edit';

//Ride
const SINDRIDEREQUEST = 'ride/request-ride';
const RESERVATIONREQUEST = 'reservation-request';
const CANCELRESERVATION = 'reservation/cancel-reservation';

const SETTODESTINITION = 'ride/set-to-destination/user';

const CANCELRIDEREQUEST = 'ride/cancel-request';

const ACCEPTOFFER = 'offer/user/accept-offer';

const GETALLOFFERS = 'offer/user/get-all-offers';

const GETRESERVATION = 'reservation/get-reservation/request';

const GETACTIVERIDE = 'ride/get-ride/user';
const GETACTIVITIES = 'activities/rides/user';

const GETPRICE = 'get-profits';

const GETNUMBERSADMIN = 'admin-numbers';

const GETRECUEST = 'ride/get-request';
const LOGOUT = 'ride/get-request';
const DELETE_ACCOUNT = 'ride/get-request';

//password  "A@123456"
//"status": true,
//     "message": "تم انشاء حسابك بنجاح",
//     "errors": [],
//     "data": {
//         "user": {
//             "name": "abdo nabil abdo",
//             "email": "abdo123@yahoo.com",
//             "phone": "01159398455",
//             "user_type": "1",
//             "picture": null,
//             "is_email_verified": false,
//             "is_phone_verified": false
//         },
//         "token": "6|Mc2qCwqZSTKJZGBw0tthx5el8TUgMbFPRXGREp7Wa2f6b56c"
//     },
//     "notes": {
//         "user_type": {
//             "1": "تعني مسوق",
//             "2": "تعني تاجر"
//         },
//         "joind_with": {
//             "1": "تعني تسجيل يدوي",
//             "2": "تعني تسجيل عن طريق جوجل ولا يشترط ارسال كلمة مرور",
//             "3": "تعني تسجيل عن طريق فيس بوك ولا يشترط ارسال كلمة مرور"
//         }
//     }
// }
