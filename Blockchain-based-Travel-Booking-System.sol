// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract TravelBooking {
    address public owner;

    enum BookingStatus { Pending, Confirmed, Cancelled }

    struct Booking {
        address user;
        string bookingType; // "Flight" or "Hotel"
        string details;
        uint256 amount;
        BookingStatus status;
        uint256 timestamp;
    }

    mapping(uint256 => Booking) public bookings;
    uint256 public bookingCounter;

    event BookingCreated(uint256 bookingId, address indexed user, string bookingType, string details, uint256 amount, uint256 timestamp);
    event BookingStatusUpdated(uint256 bookingId, BookingStatus status);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier validAmount(uint256 _amount) {
        require(_amount > 0, "Amount must be greater than zero");
        _;
    }

    constructor() {
        owner = msg.sender;
        bookingCounter = 0;
    }

    function bookFlight(string memory _details, uint256 _amount) public validAmount(_amount) {
        bookingCounter++;
        bookings[bookingCounter] = Booking(msg.sender, "Flight", _details, _amount, BookingStatus.Pending, block.timestamp);
        emit BookingCreated(bookingCounter, msg.sender, "Flight", _details, _amount, block.timestamp);
    }

    function bookHotel(string memory _details, uint256 _amount) public validAmount(_amount) {
        bookingCounter++;
        bookings[bookingCounter] = Booking(msg.sender, "Hotel", _details, _amount, BookingStatus.Pending, block.timestamp);
        emit BookingCreated(bookingCounter, msg.sender, "Hotel", _details, _amount, block.timestamp);
    }

    function updateBookingStatus(uint256 _bookingId, BookingStatus _status) public onlyOwner {
        require(_bookingId > 0 && _bookingId <= bookingCounter, "Invalid booking ID");
        bookings[_bookingId].status = _status;
        emit BookingStatusUpdated(_bookingId, _status);
    }

    function getBookingDetails(uint256 _bookingId) public view returns (Booking memory) {
        require(_bookingId > 0 && _bookingId <= bookingCounter, "Invalid booking ID");
        return bookings[_bookingId];
    }
}
