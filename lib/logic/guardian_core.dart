import 'dart:ui';

class RiskPattern {
  final String id;
  final String pattern;
  final String category;
  final String description;
  final int severityScore;
  final bool isHighRisk;

  RiskPattern({
    required this.id,
    required this.pattern,
    required this.category,
    required this.description,
    required this.severityScore,
    required this.isHighRisk,
  });
}

class AnalysisResult {
  final int index;
  final int length;
  final RiskPattern pattern;

  AnalysisResult(this.index, this.length, this.pattern);
}

class GuardianCore {
  // Improved Regex Strategy with "Sentence Expansion"
  
  static final List<RiskPattern> _patterns = [
    // 1. DATA SALE / MONETIZATION
    RiskPattern(
      id: 'p1',
      pattern: r'(sell|shar|trad|licens|rent|monetiz|transfer|disclos)\w*[\s\S]{0,100}(data|info|email|contact|profile|content|history|usage|activity|identifier)',
      category: "Data Sale",
      description: "This clause suggests they can sell, license, or transfer your personal data to others, often for marketing or 'business purposes'.",
      severityScore: 20,
      isHighRisk: true,
    ),
    
    // 2. INACTIVITY DELETION
    RiskPattern(
      id: 'p2',
      pattern: r'(terminat|delet|remov|suspend|cease)\w*[\s\S]{0,80}(account|profile|access|service)[\s\S]{0,80}(inactiv|log\s?in|month|year|period)',
      category: "Inactivity Deletion",
      description: "They reserve the right to delete your account and all associated data if you stop using the app for a while.",
      severityScore: 5,
      isHighRisk: false,
    ),
    
    // 3. SURVEILLANCE / TRACKING
    RiskPattern(
      id: 'p3',
      pattern: r'(track|access|collect|monitor|record|geo|location)\w*[\s\S]{0,80}(location|gps|position|audio|microphon|camera|voice|usage|behavior|habit)',
      category: "Surveillance",
      description: "This app may track your physical location, record audio, or monitor your behavioral habits without explicit context.",
      severityScore: 20,
      isHighRisk: true,
    ),
    
    // 4. RIGHTS WAIVER
    RiskPattern(
      id: 'p4',
      pattern: r'(class\s+action|jury\s+trial|court|legal\s+proceeding|lawsuit)\w*[\s\S]{0,80}(waiv|agree|arbitra|forgo|renounce|bar)',
      category: "Rights Waiver",
      description: "You are agreeing to give up your constitutional right to sue them in court or join a class action lawsuit.",
      severityScore: 20,
      isHighRisk: true,
    ),
    
    // 5. THIRD PARTIES
    RiskPattern(
      id: 'p5',
      pattern: r'(shar|provid|disclos|grant)\w*[\s\S]{0,80}(third\s*part|partner|affiliat|vendor|service\s+provider|advertis)',
      category: "Third Party Sharing",
      description: "Your data is being shared with external companies, advertisers, or 'partners' who may not be bound by this privacy policy.",
      severityScore: 10,
      isHighRisk: true,
    ),

    // 6. CONTENT GRABBING
    RiskPattern(
      id: 'p6',
      pattern: r'(grant|license|own|right)\w*[\s\S]{0,100}(irrevocable|perpetual|worldwide|royalty-free|exclusive)[\s\S]{0,100}(content|photo|image|upload|material|submission)',
      category: "Content Grabbing",
      description: "You grant them a permanent, often irrevocable license to use, sell, or modify the content/photos you upload, forever.",
      severityScore: 15,
      isHighRisk: true,
    ),

    // 7. UNILATERAL CHANGES
    RiskPattern(
      id: 'p7',
      pattern: r'(chang|modif|updat|amend|revis)\w*[\s\S]{0,80}(term|agreement|policy)[\s\S]{0,80}(without\s+notic|any\s+time|sole\s+discretion|posting|immediate)',
      category: "Unilateral Changes",
      description: "They can change the rules of this agreement at any time without notifying you. Your continued use counts as agreeing to the new rules.",
      severityScore: 10,
      isHighRisk: true,
    ),

    // 8. FORCED JURISDICTION
    RiskPattern(
      id: 'p8',
      pattern: r'(govern|resolv|adjudicat|jurisdiction|venue)\w*[\s\S]{0,80}(law|court|state|country)[\s\S]{0,40}(california|new\s+york|delaware|ireland|singapore|dubai|foreign)',
      category: "Forced Jurisdiction",
      description: "You are agreeing that any legal disputes must be fought in a specific court (often far away), making it expensive to sue them.",
      severityScore: 5,
      isHighRisk: false,
    ),

    // 9. INDEMNIFICATION
    RiskPattern(
      id: 'p9',
      pattern: r'(indemnify|hold\s+harmless|defend|liable)\w*[\s\S]{0,80}(against|claim|liability|damage|loss|expense|fee)',
      category: "Indemnification",
      description: "You agree to pay for their legal defense if your usage of the app causes them to get sued or face damages.",
      severityScore: 15,
      isHighRisk: true,
    ),

    // 10. NO REFUNDS
    RiskPattern(
      id: 'p10',
      pattern: r'(no|not|never|non)\w*[\s\S]{0,50}(refund|return|exchang|cancel)[\s\S]{0,50}(final|purchase|subscri|fee|charge)',
      category: "No Refunds",
      description: "All payments are final. You will not get your money back even if the app stops working or you cancel a subscription early.",
      severityScore: 10,
      isHighRisk: false,
    ),
  ];

  static Future<AnalysisReport> analyze(String text) async {
    int score = 100;
    List<AnalysisResult> rawMatches = [];
    
    // 1. Find all Matches and Expand to Sentence
    for (var p in _patterns) {
      RegExp regExp = RegExp(p.pattern, caseSensitive: false, multiLine: true);
      Iterable<RegExpMatch> matches = regExp.allMatches(text);
      
      for (var match in matches) {
        // Deduction logic applies to every hit found
        score -= p.severityScore;
        
        // --- SENTENCE EXPANSION LOGIC ---
        int start = match.start;
        int end = match.end;

        // Find Start: Look backwards for punctuation (. ? ! or newline)
        int sentenceStart = 0;
        for (int i = start - 1; i >= 0; i--) {
          if (RegExp(r'[.!?\n;]').hasMatch(text[i])) { // Added semicolon
            sentenceStart = i + 1;
            break;
          }
        }
        // Trim leading spaces from the start of the sentence
        while (sentenceStart < text.length && RegExp(r'\s').hasMatch(text[sentenceStart])) {
          sentenceStart++;
        }

        // Find End: Look forwards for punctuation
        int sentenceEnd = text.length;
        for (int i = end; i < text.length; i++) {
           if (RegExp(r'[.!?\n;]').hasMatch(text[i])) {
            sentenceEnd = i + 1; // Include the punctuation
            break;
          }
        }
        
        rawMatches.add(AnalysisResult(sentenceStart, sentenceEnd - sentenceStart, p));
      }
    }

    // 2. Handle Overlaps
    // If multiple risks are found in the same sentence, they will overlap.
    // We must prioritize High Risk over Low Risk, and merge them so the UI doesn't crash.
    
    // Sort matches: First by Priority (High Risk first), then by Position.
    rawMatches.sort((a, b) {
      if (a.pattern.isHighRisk && !b.pattern.isHighRisk) return -1;
      if (!a.pattern.isHighRisk && b.pattern.isHighRisk) return 1;
      return a.index.compareTo(b.index);
    });

    List<AnalysisResult> mergedFindings = [];
    
    for (var candidate in rawMatches) {
      bool isOverlapping = false;
      int candidateEnd = candidate.index + candidate.length;

      for (var existing in mergedFindings) {
        int existingEnd = existing.index + existing.length;

        // Check if ranges overlap
        // (StartA < EndB) and (EndA > StartB)
        if (candidate.index < existingEnd && candidateEnd > existing.index) {
          isOverlapping = true;
          // Since we sorted by priority (High Risk first), the 'existing' one 
          // is guaranteed to be equal or higher priority. We discard the candidate.
          break;
        }
      }

      if (!isOverlapping) {
        mergedFindings.add(candidate);
      }
    }

    // 3. Final Sort for UI Rendering
    // The TextSpan builder requires findings to be in strict order of appearance
    mergedFindings.sort((a, b) => a.index.compareTo(b.index));

    // Clamp score
    if (score < 1) score = 1;
    if (score > 100) score = 100;

    return AnalysisReport(score: score, findings: mergedFindings, originalText: text);
  }
}

class AnalysisReport {
  final int score;
  final List<AnalysisResult> findings;
  final String originalText;

  AnalysisReport({required this.score, required this.findings, required this.originalText});
}