import 'package:flutter/material.dart';
import 'package:app_dev/models/business_profile.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportsPage extends StatefulWidget {
  final BusinessProfile? businessProfile;

  const ReportsPage({super.key, required this.businessProfile});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.businessProfile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Business Reports',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _generatePDF,
                icon: const Icon(Icons.download),
                label: const Text('Export PDF'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Cash Flow Chart
          const Text(
            'Daily Cash Flow',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: _buildCashFlowChart(),
          ),
          const SizedBox(height: 24),

          // Income vs Expenses Chart
          const Text(
            'Income vs Expenses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: _buildIncomeVsExpensesChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildCashFlowChart() {
    if (widget.businessProfile!.financialEntries.isEmpty &&
        widget.businessProfile!.expenses.isEmpty) {
      return const Center(child: Text('No data available for chart'));
    }

    // Group entries by date
    final Map<DateTime, double> dailyCashFlow = {};

    // Process income
    for (var entry in widget.businessProfile!.financialEntries) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      dailyCashFlow[date] = (dailyCashFlow[date] ?? 0) + entry.amount;
    }

    // Process expenses
    for (var expense in widget.businessProfile!.expenses) {
      final date = DateTime(expense.date.year, expense.date.month, expense.date.day);
      dailyCashFlow[date] = (dailyCashFlow[date] ?? 0) - expense.amount;
    }

    // Sort dates
    final sortedDates = dailyCashFlow.keys.toList()..sort();

    // Create bar chart data
    final barGroups = <BarChartGroupData>[];

    for (int i = 0; i < sortedDates.length; i++) {
      final date = sortedDates[i];
      final value = dailyCashFlow[date]!;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: value,
              color: value >= 0 ? Colors.green : Colors.red,
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: dailyCashFlow.values.fold(0.0, (max, value) => value > max ? value : max) * 1.2,
        minY: dailyCashFlow.values.fold(0.0, (min, value) => value < min ? value : min) * 1.2,
        barGroups: barGroups,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text('\$${value.toInt()}');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < sortedDates.length) {
                  final date = sortedDates[value.toInt()];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(DateFormat('MM/dd').format(date)),
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          horizontalInterval: 1000,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade300,
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: false,
        ),
      ),
    );
  }

  Widget _buildIncomeVsExpensesChart() {
    if (widget.businessProfile!.financialEntries.isEmpty &&
        widget.businessProfile!.expenses.isEmpty) {
      return const Center(child: Text('No data available for chart'));
    }

    // Calculate total income
    final totalIncome = widget.businessProfile!.financialEntries
        .fold(0.0, (sum, entry) => sum + entry.amount);

    // Calculate total expenses
    final totalExpenses = widget.businessProfile!.expenses
        .fold(0.0, (sum, expense) => sum + expense.amount);

    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: totalIncome,
            title: 'Income\n\$${totalIncome.toStringAsFixed(0)}',
            color: Colors.green,
            radius: 80,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          PieChartSectionData(
            value: totalExpenses,
            title: 'Expenses\n\$${totalExpenses.toStringAsFixed(0)}',
            color: Colors.red,
            radius: 80,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Business Report'),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Company: ${widget.businessProfile!.companyName}'),
              pw.Text('Business Type: ${widget.businessProfile!.businessType}'),
              pw.Text('Generated on: ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}'),
              pw.SizedBox(height: 20),

              pw.Header(level: 1, child: pw.Text('Financial Summary')),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Metric', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Value', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Total Income'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('\$${widget.businessProfile!.financialEntries.fold(0.0, (sum, entry) => sum + entry.amount).toStringAsFixed(2)}'),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Total Expenses'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('\$${widget.businessProfile!.totalExpenses.toStringAsFixed(2)}'),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Cash Flow'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('\$${widget.businessProfile!.cashFlow.toStringAsFixed(2)}'),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('ROI'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('${widget.businessProfile!.roi.toStringAsFixed(2)}%'),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              pw.Header(level: 1, child: pw.Text('Income Entries')),
              pw.SizedBox(height: 10),
              _buildIncomeTable(),
              pw.SizedBox(height: 20),

              pw.Header(level: 1, child: pw.Text('Expenses')),
              pw.SizedBox(height: 10),
              _buildExpensesTable(),
              pw.SizedBox(height: 20),

              pw.Header(level: 1, child: pw.Text('Investments')),
              pw.SizedBox(height: 10),
              _buildInvestmentsTable(),
              pw.SizedBox(height: 20),

              pw.Header(level: 1, child: pw.Text('Milestones')),
              pw.SizedBox(height: 10),
              _buildMilestonesTable(),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildIncomeTable() {
    if (widget.businessProfile!.financialEntries.isEmpty) {
      return pw.Text('No income entries available');
    }

    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Item', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
          ],
        ),
        ...widget.businessProfile!.financialEntries.map((entry) {
          return pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(entry.itemName),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(DateFormat('MM/dd/yyyy').format(entry.date)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text('\$${entry.amount.toStringAsFixed(2)}'),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  pw.Widget _buildExpensesTable() {
    if (widget.businessProfile!.expenses.isEmpty) {
      return pw.Text('No expenses available');
    }

    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Category', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
          ],
        ),
        ...widget.businessProfile!.expenses.map((expense) {
          return pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(expense.description),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(expense.category),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(DateFormat('MM/dd/yyyy').format(expense.date)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text('\$${expense.amount.toStringAsFixed(2)}'),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  pw.Widget _buildInvestmentsTable() {
    if (widget.businessProfile!.investments.isEmpty) {
      return pw.Text('No investments available');
    }

    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Source', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Type', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
          ],
        ),
        ...widget.businessProfile!.investments.map((investment) {
          return pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(investment.source),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(investment.type),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(DateFormat('MM/dd/yyyy').format(investment.date)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text('\$${investment.amount.toStringAsFixed(2)}'),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  pw.Widget _buildMilestonesTable() {
    if (widget.businessProfile!.milestones.isEmpty) {
      return pw.Text('No milestones available');
    }

    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Title', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Target Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Status', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
          ],
        ),
        ...widget.businessProfile!.milestones.map((milestone) {
          return pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(milestone.title),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(milestone.description),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(DateFormat('MM/dd/yyyy').format(milestone.targetDate)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(milestone.isCompleted ? 'Completed' : 'Pending'),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }
}
