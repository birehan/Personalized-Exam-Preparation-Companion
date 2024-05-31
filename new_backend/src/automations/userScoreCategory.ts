import { Request, Response, NextFunction } from 'express';
import UserScoreCategory from '../models/userScoreCategory';
import UserStatistics from '../models/userStatistics';

const updateUserScoreCategories = async (req: Request, res: Response, next: NextFunction) => {
    try {
        // Check and delete existing categories
        await UserScoreCategory.deleteMany({});

        const categories = await calculateAndCategorizeScores();

        await UserScoreCategory.insertMany(categories);

        // Respond with success message
        const response = {
            success: true,
            message: 'User score categories updated successfully!',
            data: { categories }
        };

        return res.status(200).json(response);
    } catch (error) {
        next(error);
    }
};

///helpers
async function calculateAndCategorizeScores() {
    // Fetch all scores
    const allScores = await UserStatistics.find().select('points').exec();
    const scores = allScores.map(user => user.points);
    
    if (scores.length === 0) {
      throw new Error("No scores found in the database.");
    }
  
    const maxScore = Math.max(...scores);
    const minScore = Math.min(...scores);
  
    // Create 10 equal score categories from highest to lowest
    const range = maxScore - minScore;
    const interval = range / 10;
  
    const categories = Array.from({ length: 10 }, (_, i) => ({
      start: maxScore - i * interval,
      end: i === 9 ? minScore : maxScore - (i + 1) * interval,
      count: 0,
      percentile: 0,
      top: (i + 1) * 10
    }));
  
    // Categorize users
    scores.forEach(score => {
      for (let category of categories) {
        if (score <= category.start && score > category.end) {
          category.count++;
          break;
        }
      }
    });
  
    // Calculate percentile
    const totalUsers = scores.length;
    let cumulativeCount = 0;
  
    categories.forEach((category, index) => {
      cumulativeCount += category.count;
      category.percentile = ((totalUsers - cumulativeCount) / totalUsers) * 100;
    });
    
    return categories;
  }

const automationController = { updateUserScoreCategories}

export default automationController