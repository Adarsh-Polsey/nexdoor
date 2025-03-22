import 'package:flutter/material.dart';
import 'package:nexdoor/features/business/models/business_model.dart';
import 'package:nexdoor/features/business/viewmodel/business_details_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class BusinessDetailScreen extends StatefulWidget {
  final String id;

  const BusinessDetailScreen({super.key, required this.id});

  @override
  _BusinessDetailScreenState createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  
  @override
  void initState() {
    super.initState();
    // Load business details when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BusinessDetailViewModel>(context, listen: false)
          .loadBusinessDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessDetailViewModel>(
      builder: (context, viewModel, child) {
        final business = viewModel.business;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(business?.name ?? 'Business Details'),
            elevation: 0,
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : business == null
                  ? Center(child: Text(viewModel.errorMessage ?? 'No business data found'))
                  : _buildBusinessDetails(context, viewModel, business),
        );
      },
    );
  }

  Widget _buildBusinessDetails(
    BuildContext context, 
    BusinessDetailViewModel viewModel, 
    BusinessModel business
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Info Section
            _buildBusinessInfo(business),
            const SizedBox(height: 24),

            // Services Section
            Text(
              'Services',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            _buildServicesList(viewModel, business),
            const SizedBox(height: 24),

            // Booking Section (only shown if a service is selected)
            if (viewModel.selectedService != null) ...[
              Text(
                'Book ${viewModel.selectedService!.name}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              
              // Calendar
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 60)),
                    focusedDay: viewModel.selectedDate,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(viewModel.selectedDate, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      viewModel.selectDate(selectedDay);
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Time Slots Grid
              viewModel.errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : viewModel.availableTimeSlots.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No available time slots for this day',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      : _buildTimeSlots(viewModel),
              const SizedBox(height: 24),

              // Booking Button
              if (viewModel.selectedTimeSlot != null)
                Center(
                  child: ElevatedButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () => _handleBookingSubmit(context, viewModel),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      viewModel.isLoading
                          ? 'Booking...'
                          : 'Book Now',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessInfo(BusinessModel business) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              business.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              business.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.category, size: 18),
                const SizedBox(width: 8),
                Text(business.category),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 18),
                const SizedBox(width: 8),
                Text(business.address),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 18),
                const SizedBox(width: 8),
                Text(business.phone),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.email, size: 18),
                const SizedBox(width: 8),
                Text(business.email),
              ],
            ),
            if (business.website.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.language, size: 18),
                  const SizedBox(width: 8),
                  Text(business.website),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList(BusinessDetailViewModel viewModel, BusinessModel business) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: business.services.length,
      itemBuilder: (context, index) {
        final service = business.services[index];
        final isSelected = viewModel.selectedService?.id == service.id;
        
        return Card(
          elevation: isSelected ? 8 : 2,
          margin: const EdgeInsets.only(bottom: 12),
          color: isSelected ? Colors.blue.shade50 : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected
                ? const BorderSide(color: Colors.blue, width: 2)
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: () => viewModel.selectService(service),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${service.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      Text('${service.duration} mins'),
                      const SizedBox(width: 16),
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          service.availableDays.join(', '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeSlots(BusinessDetailViewModel viewModel) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Times for ${DateFormat('EEEE, MMM d').format(viewModel.selectedDate)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: viewModel.availableTimeSlots.length,
              itemBuilder: (context, index) {
                final slot = viewModel.availableTimeSlots[index];
                final isSelected = viewModel.selectedTimeSlot == slot.time;
                
                return InkWell(
                  onTap: slot.isAvailable
                      ? () => viewModel.selectTimeSlot(slot.time)
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: !slot.isAvailable
                          ? Colors.grey.shade200
                          : isSelected
                              ? Colors.blue
                              : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      slot.time,
                      style: TextStyle(
                        color: !slot.isAvailable
                            ? Colors.grey.shade500
                            : isSelected
                                ? Colors.white
                                : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleBookingSubmit(BuildContext context, BusinessDetailViewModel viewModel) async {
    await viewModel.createBooking();
    
    if (viewModel.bookingSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Reset booking form state
      viewModel.resetBookingState();
    }
  }
}
