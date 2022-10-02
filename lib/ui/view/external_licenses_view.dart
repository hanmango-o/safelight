import 'package:flutter/material.dart';
import 'package:safelight/asset/static/license_docs.dart';
import 'package:safelight/asset/static/size_theme.dart';
import 'package:safelight/ui/widget/single_child_rounded_card.dart';

class ExternalLicensesView extends StatelessWidget {
  const ExternalLicensesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('외부 라이센스'),
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: SizeTheme.h_lg,
          horizontal: SizeTheme.w_md,
        ),
        child: Column(
          children: LicenseDOCS.externalLicenses
              .map(
                (e) => Padding(
                  padding: EdgeInsets.only(bottom: SizeTheme.h_lg),
                  child: SingleChildRoundedCard(
                    padding: EdgeInsets.all(SizeTheme.w_sm),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: SizeTheme.h_lg),
                          child: Text(
                            e['name']!,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Text(
                          e['license']!,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

/*
SingleChildRoundedCard(
              padding: EdgeInsets.all(SizeTheme.w_sm),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: SizeTheme.h_lg),
                    child: Text(
                      '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    '',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
*/